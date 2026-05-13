import 'package:yummy/data/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Book', () {
    test('can instantiate', () {
      late Book book;

      book = const Book();

      expect(book, isNotNull);
    });
    test('can receive parameters', () {
      late Book book;
      const id = 123;
      const label = 'Pasta with Garlic, Scallions, Cauliflower & Breadcrumbs';
      const image = 'https://spoonacular.com/recipeImages/716429-556x370.jpg';
      const description =
          'Pasta with Garlic, Scallions, Cauliflower & Breadcrumbs might be a good recipe to expand your main course repertoire.';
      const bookmarked = true;
      const tags = [
        BookTag(
          id: 1123,
          bookId: 123,
          name: 'Pasta',
          amount: 1.0,
        ),
        BookTag(
          id: 1124,
          bookId: 123,
          name: 'Garlic',
          amount: 1.0,
        ),
        BookTag(
          id: 1125,
          bookId: 123,
          name: 'Breadcrumbs',
          amount: 5.0,
        ),
      ];

      book = const Book(
        id: id,
        label: label,
        image: image,
        description: description,
        bookmarked: bookmarked,
        tags: tags,
      );

      expect(book.id, equals(id));
      expect(book.label, equals(label));
      expect(book.image, equals(image));
      expect(book.description, equals(description));
      expect(book.bookmarked, equals(bookmarked));
      expect(book.tags, equals(tags));
    });
  });
}
