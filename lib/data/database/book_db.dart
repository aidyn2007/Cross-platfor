import 'package:drift/drift.dart';

import 'connection.dart' as impl;
import '../models/models.dart';

part 'book_db.g.dart';

class DbBook extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get label => text()();

  TextColumn get image => text()();

  TextColumn get description => text()();

  BoolColumn get bookmarked => boolean()();
}

class DbBookTag extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get bookId => integer()();

  TextColumn get name => text()();

  RealColumn get amount => real()();
}

@DriftDatabase(
  tables: [DbBook, DbBookTag],
  daos: [BookDao, BookTagDao],
)
class BookDatabase extends _$BookDatabase {
  BookDatabase() : super(impl.connect());

  @override
  int get schemaVersion => 1;
}

@DriftAccessor(tables: [DbBook])
class BookDao extends DatabaseAccessor<BookDatabase> with _$BookDaoMixin {
  final BookDatabase db;

  BookDao(this.db) : super(db);

  Future<List<DbBookData>> findAllBooks() => select(dbBook).get();

  Stream<List<Book>> watchAllBooks() {
    return select(dbBook).watch().map(
      (rows) {
        final books = <Book>[];
        for (final row in rows) {
          final book = dbBookToModelBook(row, <BookTag>[]);
          if (!books.contains(book)) {
            books.add(book);
          }
        }
        return books;
      },
    );
  }

  Future<List<DbBookData>> findBookById(int id) =>
      (select(dbBook)..where((tbl) => tbl.id.equals(id))).get();

  Future<int> insertBook(Insertable<DbBookData> book) =>
      into(dbBook).insert(book);

  Future deleteBook(int id) =>
      Future.value((delete(dbBook)..where((tbl) => tbl.id.equals(id))).go());
}

@DriftAccessor(tables: [DbBookTag])
class BookTagDao extends DatabaseAccessor<BookDatabase>
    with _$BookTagDaoMixin {
  final BookDatabase db;

  BookTagDao(this.db) : super(db);

  Future<List<DbBookTagData>> findAllTags() =>
      select(dbBookTag).get();

  Stream<List<DbBookTagData>> watchAllTags() =>
      select(dbBookTag).watch();

  Future<List<DbBookTagData>> findBookTags(int id) =>
      (select(dbBookTag)..where((tbl) => tbl.bookId.equals(id))).get();

  Future<int> insertTag(Insertable<DbBookTagData> tag) =>
      into(dbBookTag).insert(tag);

  Future deleteTag(int id) => Future.value(
      (delete(dbBookTag)..where((tbl) => tbl.id.equals(id))).go());
}

// Conversion Methods

Book dbBookToModelBook(DbBookData book, List<BookTag> tags) {
  return Book(
    id: book.id,
    label: book.label,
    image: book.image,
    description: book.description,
    bookmarked: book.bookmarked,
    tags: tags,
  );
}

Insertable<DbBookData> bookToInsertableDbBook(Book book) {
  return DbBookCompanion.insert(
    label: book.label ?? '',
    image: book.image ?? '',
    description: book.description ?? '',
    bookmarked: book.bookmarked,
  );
}

BookTag dbBookTagToBookTag(DbBookTagData tag) {
  return BookTag(
    id: tag.id,
    bookId: tag.bookId,
    name: tag.name,
    amount: tag.amount,
  );
}

DbBookTagCompanion bookTagToInsertableDbBookTag(BookTag tag) {
  return DbBookTagCompanion.insert(
    bookId: tag.bookId ?? 0,
    name: tag.name ?? '',
    amount: tag.amount ?? 0,
  );
}
