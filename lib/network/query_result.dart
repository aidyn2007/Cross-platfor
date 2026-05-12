import '../data/models/models.dart';

class QueryResult {
  final int offset;
  final int number;
  final int totalResults;
  final List<Recipe> recipes;

  QueryResult({
    required this.offset,
    required this.number,
    required this.totalResults,
    required this.recipes,
  });

  factory QueryResult.fromJson(Map<String, dynamic> json) => QueryResult(
        offset: json['offset'] as int,
        number: json['number'] as int,
        totalResults: json['totalResults'] as int,
        recipes: (json['recipes'] as List<dynamic>)
            .map((e) => Recipe.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'offset': offset,
        'number': number,
        'totalResults': totalResults,
        'recipes': recipes.map((e) => e.toJson()).toList(),
      };
}
