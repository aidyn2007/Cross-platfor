import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:yummy/data/database/book_db.dart';
import 'package:yummy/data/models/models.dart';
import 'package:yummy/data/repositories/db_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'db_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<BookDatabase>(),
  MockSpec<BookDao>(),
  MockSpec<BookTagDao>(),
])
void main() {
  final mockDb = MockBookDatabase();
  final mockBookTagDao = MockBookTagDao();
  final mockBookDao = MockBookDao();

  when(mockDb.bookTagDao).thenReturn(mockBookTagDao);
  when(mockDb.bookDao).thenReturn(mockBookDao);

  final randomTags = [
    const BookTag(
      id: 1123,
      bookId: 123,
      name: 'Pasta',
      amount: 1.0,
    ),
    const BookTag(
      id: 1124,
      bookId: 123,
      name: 'Garlic',
      amount: 1.0,
    ),
    const BookTag(
      id: 1125,
      bookId: 123,
      name: 'Breadcrumbs',
      amount: 5.0,
    ),
  ];

  group('DBRepository', () {
    test('can instantiate', () {
      late DBRepository dbRepository;

      dbRepository = DBRepository(
        bookDatabase: mockDb,
      );

      expect(dbRepository, isNotNull);
      expect(dbRepository.bookDatabase, isNotNull);
    });

    test('can findAllTags', () async {
      final dbRepository = DBRepository(
        bookDatabase: mockDb,
      );
      await dbRepository.init();
      when(mockBookTagDao.findAllTags()).thenAnswer(
        (_) async => randomTags
            .map((e) => DbBookTagData(
                  id: e.id!,
                  bookId: e.bookId!,
                  name: e.name!,
                  amount: e.amount!,
                ))
            .toList(),
      );

      final result = await dbRepository.findAllTags();

      verify(mockBookTagDao.findAllTags()).called(1);
      expect(result, equals(randomTags));
    });
  });
}
