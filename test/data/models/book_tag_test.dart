import 'package:yummy/data/models/book_tag.dart';
import 'package:test/test.dart';

void main() {
  group('BookTag', () {
    test('can instantiate', () {
      late BookTag tag;

      tag = const BookTag();

      expect(tag, isNotNull);
    });
    test('can set default properties', () {
      late BookTag tag;

      tag = const BookTag();

      expect(tag.id, isNull);
      expect(tag.bookId, isNull);
      expect(tag.name, isNull);
      expect(tag.amount, isNull);
    });
    test('can receive parameters', () {
      late BookTag tag;
      const id = 123;
      const bookId = 54321;
      const name = 'Parmesan Cheese';
      const amount = 1.0;

      tag = const BookTag(
        id: id,
        bookId: bookId,
        name: name,
        amount: amount,
      );

      expect(tag.id, equals(id));
      expect(tag.bookId, equals(bookId));
      expect(tag.name, equals(name));
      expect(tag.amount, equals(amount));
    });
    test('can instantiate from JSON', () {
      late BookTag tag;
      final jsonMap = <String, dynamic>{
        'id': 123,
        'bookId': 54321,
        'name': 'Parmesan Cheese',
        'amount': 1,
      };
      const id = 123;
      const bookId = 54321;
      const name = 'Parmesan Cheese';
      const amount = 1.0;

      tag = BookTag.fromJson(jsonMap);

      expect(tag.id, equals(id));
      expect(tag.bookId, equals(bookId));
      expect(tag.name, equals(name));
      expect(tag.amount, equals(amount));
    });
  });
}
