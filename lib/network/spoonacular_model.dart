import '../data/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'spoonacular_model.g.dart';

@JsonSerializable()
class SpoonacularResults {
  List<SpoonacularResult> results;
  int offset;
  int number;
  int totalResults;

  SpoonacularResults({
    required this.results,
    required this.offset,
    required this.number,
    required this.totalResults,
  });

  factory SpoonacularResults.fromJson(Map<String, dynamic> json) =>
      _$SpoonacularResultsFromJson(json);

  Map<String, dynamic> toJson() => _$SpoonacularResultsToJson(this);
}

@JsonSerializable()
class SpoonacularResult {
  int id;
  String title;
  String image;
  String imageType;

  SpoonacularResult({
    required this.id,
    required this.title,
    required this.image,
    required this.imageType,
  });

  factory SpoonacularResult.fromJson(Map<String, dynamic> json) =>
      _$SpoonacularResultFromJson(json);

  Map<String, dynamic> toJson() => _$SpoonacularResultToJson(this);
}

@JsonSerializable()
class SpoonacularRecipe {
  int preparationMinutes;
  int cookingMinutes;
  String sourceName;
  List<ExtendedIngredient> extendedIngredients;
  int id;
  String title;
  int readyInMinutes;
  int servings;
  String sourceUrl;
  String image;
  String imageType;
  String summary;
  String? instructions;

  SpoonacularRecipe({
    required this.preparationMinutes,
    required this.cookingMinutes,
    required this.sourceName,
    required this.extendedIngredients,
    required this.id,
    required this.title,
    required this.readyInMinutes,
    required this.servings,
    required this.sourceUrl,
    required this.image,
    required this.imageType,
    required this.summary,
    this.instructions,
  });
  factory SpoonacularRecipe.fromJson(Map<String, dynamic> json) =>
      _$SpoonacularRecipeFromJson(json);

  Map<String, dynamic> toJson() => _$SpoonacularRecipeToJson(this);
}

@JsonSerializable()
class ExtendedIngredient {
  int id;
  String? aisle;
  String? image;
  String name;
  String? nameClean;
  String original;
  String? originalName;
  double amount;
  String unit;

  ExtendedIngredient({
    required this.id,
    required this.aisle,
    required this.image,
    required this.name,
    required this.nameClean,
    required this.original,
    required this.originalName,
    required this.amount,
    required this.unit,
  });
  factory ExtendedIngredient.fromJson(Map<String, dynamic> json) =>
      _$ExtendedIngredientFromJson(json);

  Map<String, dynamic> toJson() => _$ExtendedIngredientToJson(this);
}

List<Book> spoonacularResultsToBook(SpoonacularResults result) {
  final books = <Book>[];
  for (final result in result.results) {
    books.add(spoonacularToBook(result));
  }
  return books;
}

Book spoonacularToBook(SpoonacularResult result) {
  return Book(
      id: result.id,
      image: result.image,
      label: result.title,
      bookmarked: false,
      tags: const <BookTag>[],
      description: result.title);
}

Book spoonacularRecipeToBook(SpoonacularRecipe spoonacularBook) {
  final tags = <BookTag>[];
  for (final tag in spoonacularBook.extendedIngredients) {
    tags.add(BookTag(
        id: tag.id,
        name: tag.name,
        amount: tag.amount,
        bookId: spoonacularBook.id));
  }
  return Book(
    id: spoonacularBook.id,
    label: spoonacularBook.title,
    image: spoonacularBook.image,
    bookmarked: false,
    description: spoonacularBook.summary,
    tags: tags,
  );
}
