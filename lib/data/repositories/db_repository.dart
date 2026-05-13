import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/current_book_data.dart';
import '../models/models.dart';
import 'repository.dart';
import '../database/book_db.dart';

class DBRepository extends Notifier<CurrentBookData> implements Repository {
  late BookDatabase bookDatabase;
  late BookDao _bookDao;
  late BookTagDao _bookTagDao;
  Stream<List<BookTag>>? tagStream;
  Stream<List<Book>>? bookStream;

  DBRepository({BookDatabase? bookDatabase})
      : bookDatabase = bookDatabase ?? BookDatabase();

  @override
  CurrentBookData build() {
    const currentBookData = CurrentBookData();
    return currentBookData;
  }

  @override
  Future<List<Book>> findAllBooks() {
    return _bookDao.findAllBooks().then<List<Book>>(
      (List<DbBookData> dbBooks) async {
        final books = <Book>[];
        for (final dbBook in dbBooks) {
          final tags = await findBookTags(dbBook.id);
          final book = dbBookToModelBook(dbBook, tags);
          books.add(book);
        }
        return books;
      },
    );
  }

  @override
  Stream<List<Book>> watchAllBooks() {
    bookStream ??= _bookDao.watchAllBooks();
    return bookStream!;
  }

  @override
  Stream<List<BookTag>> watchAllTags() {
    if (tagStream == null) {
      final stream = _bookTagDao.watchAllTags();
      tagStream = stream.map(
        (dbTags) {
          final tags = <BookTag>[];
          for (final dbTag in dbTags) {
            tags.add(dbBookTagToBookTag(dbTag));
          }
          return tags;
        },
      );
    }
    return tagStream!;
  }

  @override
  Future<Book> findBookById(int id) async {
    final tags = await findBookTags(id);
    return _bookDao
        .findBookById(id)
        .then((listOfBooks) => dbBookToModelBook(listOfBooks.first, tags));
  }

  @override
  Future<List<BookTag>> findAllTags() {
    return _bookTagDao.findAllTags().then<List<BookTag>>(
      (List<DbBookTagData> dbTags) {
        final tags = <BookTag>[];
        for (final tag in dbTags) {
          tags.add(dbBookTagToBookTag(tag));
        }
        return tags;
      },
    );
  }

  @override
  Future<List<BookTag>> findBookTags(int bookId) {
    return _bookTagDao.findBookTags(bookId).then(
      (listOfTags) {
        final tags = <BookTag>[];
        for (final tag in listOfTags) {
          tags.add(dbBookTagToBookTag(tag));
        }
        return tags;
      },
    );
  }

  @override
  Future<int> insertBook(Book book) {
    if (state.currentBooks.contains(book)) {
      return Future.value(0);
    }
    return Future(
      () async {
        state =
            state.copyWith(currentBooks: [...state.currentBooks, book]);
        final id = await _bookDao.insertBook(
          bookToInsertableDbBook(book),
        );
        final tags = <BookTag>[];
        for (final tag in book.tags) {
          tags.add(tag.copyWith(bookId: id));
        }
        insertTags(tags);
        return id;
      },
    );
  }

  @override
  Future<List<int>> insertTags(List<BookTag> tags) {
    return Future(
      () {
        if (tags.isEmpty) {
          return <int>[];
        }
        final resultIds = <int>[];
        for (final tag in tags) {
          final dbTag = bookTagToInsertableDbBookTag(tag);
          _bookTagDao
              .insertTag(dbTag)
              .then((int id) => resultIds.add(id));
        }
        state = state.copyWith(
            currentTags: [...state.currentTags, ...tags]);
        return resultIds;
      },
    );
  }

  @override
  Future<void> deleteBook(Book book) {
    if (book.id != null) {
      final updatedList = [...state.currentBooks];
      updatedList.remove(book);
      state = state.copyWith(currentBooks: updatedList);
      _bookDao.deleteBook(book.id!);
      deleteBookTags(book.id!);
    }
    return Future.value();
  }

  @override
  Future<void> deleteTag(BookTag tag) {
    if (tag.id != null) {
      final updatedList = [...state.currentTags];
      updatedList.remove(tag);
      state = state.copyWith(currentTags: updatedList);
      return _bookTagDao.deleteTag(tag.id!);
    } else {
      return Future.value();
    }
  }

  @override
  Future<void> deleteTags(List<BookTag> tags) {
    for (final tag in tags) {
      if (tag.id != null) {
        final updatedList = [...state.currentTags];
        updatedList.removeWhere((t) => tags.contains(t));
        state = state.copyWith(currentTags: updatedList);
        _bookTagDao.deleteTag(tag.id!);
      }
    }
    return Future.value();
  }

  @override
  Future<void> deleteBookTags(int bookId) async {
    final updatedList = [...state.currentTags];
    updatedList.removeWhere((tag) => tag.bookId == bookId);
    state = state.copyWith(currentTags: updatedList);
    final tags = await findBookTags(bookId);
    return deleteTags(tags);
  }

  @override
  Future init() async {
    _bookDao = bookDatabase.bookDao;
    _bookTagDao = bookDatabase.bookTagDao;
  }

  @override
  void close() {
    bookDatabase.close();
  }
}
