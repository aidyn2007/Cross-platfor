import 'ingredient.dart';

class Recipe {
  final int? id;
  final String? sourceId;
  final String? label;
  final String? image;
  final String? description;
  final bool bookmarked;
  final List<Ingredient> ingredients;

  const Recipe({
    this.id,
    this.sourceId,
    this.label,
    this.image,
    this.description,
    this.bookmarked = false,
    this.ingredients = const <Ingredient>[],
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json['id'] as int?,
        sourceId: json['sourceId'] as String?,
        label: json['label'] as String?,
        image: json['image'] as String?,
        description: json['description'] as String?,
        bookmarked: json['bookmarked'] as bool? ?? false,
        ingredients: (json['ingredients'] as List<dynamic>?)
                ?.map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const <Ingredient>[],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'sourceId': sourceId,
        'label': label,
        'image': image,
        'description': description,
        'bookmarked': bookmarked,
        'ingredients': ingredients.map((e) => e.toJson()).toList(),
      };

  Recipe copyWith({
    int? id,
    String? sourceId,
    String? label,
    String? image,
    String? description,
    bool? bookmarked,
    List<Ingredient>? ingredients,
  }) {
    return Recipe(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      label: label ?? this.label,
      image: image ?? this.image,
      description: description ?? this.description,
      bookmarked: bookmarked ?? this.bookmarked,
      ingredients: ingredients ?? this.ingredients,
    );
  }
}
