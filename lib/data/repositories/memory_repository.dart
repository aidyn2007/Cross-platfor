import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import 'repository.dart';

class MemoryRepository extends Notifier<CurrentBookData> implements Repository {
  late Stream<List<Book>> _bookStream;
  late Stream<List<BookTag>> _tagStream;
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      _favoriteBooksSubscription;

  final Map<String, Book> _localFavoriteBooks = <String, Book>{};
  final Set<String> _deletedFavoriteBookIds = <String>{};
  List<Book> _remoteFavoriteBooks = <Book>[];
  String? _currentUserId;

  late final FirebaseAuth _auth;
  late final FirebaseFirestore _firestore;

  final StreamController<List<Book>> _bookStreamController =
      StreamController<List<Book>>();
  final StreamController<List<BookTag>> _tagStreamController =
      StreamController<List<BookTag>>();

  MemoryRepository() {
    _bookStream = _bookStreamController.stream.asBroadcastStream(
      onListen: (subscription) {
        _emitBooks();
      },
    );
    _tagStream = _tagStreamController.stream.asBroadcastStream(
      onListen: (subscription) {
        _tagStreamController.sink.add(state.currentTags);
      },
    );
  }

  @override
  CurrentBookData build() {
    // Инициализируем здесь
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;

    _authSubscription = _auth.authStateChanges().listen(_listenToRemoteBooks);
    Future.microtask(() => _listenToRemoteBooks(_auth.currentUser));
    ref.onDispose(() {
      _authSubscription?.cancel();
      _favoriteBooksSubscription?.cancel();
      close();
    });
    return const CurrentBookData();
  }

  @override
  Stream<List<Book>> watchAllBooks() => _bookStream;

  @override
  Stream<List<BookTag>> watchAllTags() => _tagStream;

  @override
  Future<List<Book>> findAllBooks() => Future.value(state.currentBooks);

  @override
  Future<Book> findBookById(int id) =>
      Future.value(state.currentBooks.firstWhere((book) => book.id == id));

  @override
  Future<List<BookTag>> findAllTags() => Future.value(state.currentTags);

  @override
  Future<List<BookTag>> findBookTags(int bookId) async {
    return state.currentTags.where((tag) => tag.bookId == bookId).toList();
  }

  @override
  Future<int> insertBook(Book book) async {
    final savedBook = book.copyWith(bookmarked: true);
    final bookId = _favoriteBookId(savedBook);
    final alreadySaved = state.currentBooks.any(
      (currentBook) => _favoriteBookId(currentBook) == bookId,
    );

    if (alreadySaved) return 0;

    _deletedFavoriteBookIds.remove(bookId);
    _localFavoriteBooks[bookId] = savedBook;
    _publishBooks();

    final tags = savedBook.tags
        .map((tag) => tag.copyWith(bookId: savedBook.id))
        .toList();
    insertTags(tags);
    unawaited(_saveFavoriteBook(savedBook));
    return 0;
  }

  @override
  Future<List<int>> insertTags(List<BookTag> tags) async {
    if (tags.isNotEmpty) {
      state = state.copyWith(currentTags: [...state.currentTags, ...tags]);
      _tagStreamController.sink.add(state.currentTags);
    }
    return <int>[];
  }

  @override
  Future<void> deleteBook(Book book) async {
    final bookId = _favoriteBookId(book);
    _deletedFavoriteBookIds.add(bookId);
    _localFavoriteBooks.remove(bookId);
    _remoteFavoriteBooks.removeWhere(
      (currentBook) => _favoriteBookId(currentBook) == bookId,
    );
    _publishBooks();

    unawaited(_deleteFavoriteBook(book));
    if (book.id != null) deleteBookTags(book.id!);
  }

  @override
  Future<void> deleteTag(BookTag tag) async {
    final updatedList = [...state.currentTags]..remove(tag);
    state = state.copyWith(currentTags: updatedList);
    _tagStreamController.sink.add(state.currentTags);
  }

  @override
  Future<void> deleteTags(List<BookTag> tags) async {
    final updatedList = [...state.currentTags]
      ..removeWhere((tag) => tags.contains(tag));
    state = state.copyWith(currentTags: updatedList);
    _tagStreamController.sink.add(state.currentTags);
  }

  @override
  Future<void> deleteBookTags(int bookId) async {
    final updatedList = [...state.currentTags]
      ..removeWhere((tag) => tag.bookId == bookId);
    state = state.copyWith(currentTags: updatedList);
    _tagStreamController.sink.add(state.currentTags);
  }

  @override
  Future init() async {}

  @override
  void close() {
    if (!_bookStreamController.isClosed) _bookStreamController.close();
    if (!_tagStreamController.isClosed) _tagStreamController.close();
  }

  void _listenToRemoteBooks(User? user) {
    _favoriteBooksSubscription?.cancel();
    if (user == null) {
      _currentUserId = null;
      _localFavoriteBooks.clear();
      _remoteFavoriteBooks = <Book>[];
      _deletedFavoriteBookIds.clear();
      _publishBooks();
      return;
    }

    if (_currentUserId != user.uid) {
      _currentUserId = user.uid;
      _localFavoriteBooks.clear();
      _remoteFavoriteBooks = <Book>[];
      _deletedFavoriteBookIds.clear();
      _publishBooks();
    }

    _favoriteBooksSubscription = _favoriteBooksCollection(user.uid)
        .orderBy('savedAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _remoteFavoriteBooks = snapshot.docs
          .map((document) => Book.fromJson(document.data()))
          .map((book) => book.copyWith(bookmarked: true))
          .toList();

      final remoteBookIds = _remoteFavoriteBooks.map(_favoriteBookId).toSet();
      _localFavoriteBooks.removeWhere(
        (bookId, book) => remoteBookIds.contains(bookId),
      );
      _deletedFavoriteBookIds.removeWhere(
        (bookId) => !remoteBookIds.contains(bookId),
      );
      _publishBooks();
    }, onError: (error) => log('Error loading books: $error'));
  }

  CollectionReference<Map<String, dynamic>> _favoriteBooksCollection(
    String userId,
  ) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favorite_books');
  }

  Future<void> _saveFavoriteBook(Book book) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;
      await _favoriteBooksCollection(user.uid).doc(_favoriteBookId(book)).set({
        ...book.toJson(),
        'savedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }

  Future<void> _deleteFavoriteBook(Book book) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;
      await _favoriteBooksCollection(user.uid)
          .doc(_favoriteBookId(book))
          .delete();
    } catch (_) {}
  }

  void _publishBooks() {
    final booksById = <String, Book>{};

    for (final book in _remoteFavoriteBooks) {
      final bookId = _favoriteBookId(book);
      if (!_deletedFavoriteBookIds.contains(bookId)) {
        booksById[bookId] = book.copyWith(bookmarked: true);
      }
    }

    for (final book in _localFavoriteBooks.values) {
      final bookId = _favoriteBookId(book);
      if (!_deletedFavoriteBookIds.contains(bookId)) {
        booksById[bookId] = book.copyWith(bookmarked: true);
      }
    }

    state = state.copyWith(currentBooks: booksById.values.toList());
    _emitBooks();
  }

  void _emitBooks() {
    if (!_bookStreamController.isClosed) {
      _bookStreamController.sink.add(state.currentBooks);
    }
  }

  String _favoriteBookId(Book book) {
    final rawId = book.sourceId ?? book.id?.toString() ?? book.label;
    return (rawId ?? DateTime.now().microsecondsSinceEpoch.toString())
        .replaceAll('/', '_');
  }
}
