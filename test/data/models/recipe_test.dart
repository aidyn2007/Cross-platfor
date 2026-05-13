import 'package:yummy/data/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Recipe', () {
    test('can instantiate', () {
      // Arrange
      late Recipe recipe;

      // Act
      recipe = const Recipe();

      // Assert
      expect(recipe, isNotNull);
    });
    test('can receive parameters', () {
      late Recipe recipe;
      const id = 123;
      const label = 'Pasta with Garlic, Scallions, Cauliflower & Breadcrumbs';
      const image = 'https://spoonacular.com/recipeImages/716429-556x370.jpg';
      const description =
          'Pasta with Garlic, Scallions, Cauliflower & Breadcrumbs might be a good recipe to expand your main course repertoire.';
      const bookmarked = true;
      const ingredients = [
        Ingredient(
          id: 1123,
          recipeId: 123,
          name: 'Pasta',
          amount: 1.0,
        ),
        Ingredient(
          id: 1124,
          recipeId: 123,
          name: 'Garlic',
          amount: 1.0,
        ),
        Ingredient(
          id: 1125,
          recipeId: 123,
          name: 'Breadcrumbs',
          amount: 5.0,
        ),
      ];

      recipe = const Recipe(
        id: id,
        label: label,
        image: image,
        description: description,
        bookmarked: bookmarked,
        ingredients: ingredients,
      );

      // Assert
      expect(recipe.id, equals(id));
      expect(recipe.label, equals(label));
      expect(recipe.image, equals(image));
      expect(recipe.description, equals(description));
      expect(recipe.bookmarked, equals(bookmarked));
      expect(recipe.ingredients, equals(ingredients));
    });
  });
}
