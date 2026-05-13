import '../models/models.dart';

abstract class Repository {
  Future<List<Book>> findAllBooks();

  Stream<List<Book>> watchAllBooks();

  Stream<List<BookTag>> watchAllTags();

  Future<Book> findBookById(int id);

  Future<List<BookTag>> findAllTags();

  Future<List<BookTag>> findBookTags(int bookId);

  Future<int> insertBook(Book book);

  Future<List<int>> insertTags(List<BookTag> tags);

  Future<void> deleteBook(Book book);

  Future<void> deleteTag(BookTag tag);

  Future<void> deleteTags(List<BookTag> tags);

  Future<void> deleteBookTags(int bookId);

  Future init();
  void close();
}
