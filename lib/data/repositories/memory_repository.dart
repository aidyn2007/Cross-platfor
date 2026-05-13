import 'dart:async';
import 'dart:core';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/current_book_data.dart';
import '../models/models.dart';
import 'repository.dart';

class MemoryRepository extends Notifier<CurrentBookData>
    implements Repository {
  late Stream<List<Book>> _bookStream;
  late Stream<List<BookTag>> _tagStream;
  final StreamController _bookStreamController =
      StreamController<List<Book>>();
  final StreamController _tagStreamController =
      StreamController<List<BookTag>>();

  MemoryRepository() {
    _bookStream = _bookStreamController.stream.asBroadcastStream(
      onListen: (subscription) {
        _bookStreamController.sink.add(state.currentBooks);
      },
    ) as Stream<List<Book>>;
    _tagStream = _tagStreamController.stream.asBroadcastStream(
      onListen: (subscription) {
        _tagStreamController.sink.add(state.currentTags);
      },
    ) as Stream<List<BookTag>>;
  }

  @override
  CurrentBookData build() {
    return const CurrentBookData();
  }

  @override
  Stream<List<Book>> watchAllBooks() {
    return _bookStream;
  }

  @override
  Stream<List<BookTag>> watchAllTags() {
    return _tagStream;
  }

  @override
  Future<List<Book>> findAllBooks() {
    return Future.value(state.currentBooks);
  }

  @override
  Future<Book> findBookById(int id) {
    return Future.value(
        state.currentBooks.firstWhere((book) => book.id == id));
  }

  @override
  Future<List<BookTag>> findAllTags() {
    return Future.value(state.currentTags);
  }

  @override
  Future<List<BookTag>> findBookTags(int bookId) {
    final book =
        state.currentBooks.firstWhere((book) => book.id == bookId);
    final bookTags = state.currentTags
        .where((tag) => tag.bookId == book.id)
        .toList();
    return Future.value(bookTags);
  }

  @override
  Future<int> insertBook(Book book) {
    final alreadySaved = state.currentBooks.any((currentBook) {
      final sameSourceId =
          book.sourceId != null && currentBook.sourceId == book.sourceId;
      final sameLocalId = book.id != null && currentBook.id == book.id;

      return sameSourceId || sameLocalId;
    });

    if (alreadySaved) {
      return Future.value(0);
    }
    state = state.copyWith(currentBooks: [...state.currentBooks, book]);
    _bookStreamController.sink.add(state.currentBooks);
    final tags = <BookTag>[];
    for (final tag in book.tags) {
      tags.add(tag.copyWith(bookId: book.id));
    }
    insertTags(tags);
    return Future.value(0);
  }

  @override
  Future<List<int>> insertTags(List<BookTag> tags) {
    if (tags.isNotEmpty) {
      state = state.copyWith(
          currentTags: [...state.currentTags, ...tags]);

      _tagStreamController.sink.add(state.currentTags);
    }
    return Future.value(<int>[]);
  }

  @override
  Future<void> deleteBook(Book book) {
    final updatedList = [...state.currentBooks];
    updatedList.remove(book);
    state = state.copyWith(currentBooks: updatedList);
    _bookStreamController.sink.add(state.currentBooks);
    if (book.id != null) {
      deleteBookTags(book.id!);
    }
    return Future.value();
  }

  @override
  Future<void> deleteTag(BookTag tag) {
    final updatedList = [...state.currentTags];
    updatedList.remove(tag);
    state = state.copyWith(currentTags: updatedList);

    _tagStreamController.sink.add(state.currentTags);
    return Future.value();
  }

  @override
  Future<void> deleteTags(List<BookTag> tags) {
    final updatedList = [...state.currentTags];
    updatedList.removeWhere((tag) => tags.contains(tag));
    state = state.copyWith(currentTags: updatedList);
    _tagStreamController.sink.add(state.currentTags);
    return Future.value();
  }

  @override
  Future<void> deleteBookTags(int bookId) {
    final updatedList = [...state.currentTags];
    updatedList.removeWhere((tag) => tag.bookId == bookId);
    state = state.copyWith(currentTags: updatedList);
    _tagStreamController.sink.add(state.currentTags);
    return Future.value();
  }

  @override
  Future init() {
    return Future.value();
  }

  @override
  void close() {
    _bookStreamController.close();
    _tagStreamController.close();
  }
}
