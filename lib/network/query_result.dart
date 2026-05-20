import 'package:books/data/models/models.dart';

class QueryResult {
  final int offset;
  final int number;
  final int totalResults;
  final List<Book> books;

  QueryResult({
    required this.offset,
    required this.number,
    required this.totalResults,
    required this.books,
  });

  factory QueryResult.fromJson(Map<String, dynamic> json) => QueryResult(
        offset: json['offset'] as int? ?? 0,
        number: json['number'] as int? ?? 0,
        totalResults: json['totalResults'] as int? ?? 0,
        books: (json['items'] as List<dynamic>?)
                ?.map((e) => Book.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const <Book>[],
      );

  Map<String, dynamic> toJson() => {
        'offset': offset,
        'number': number,
        'totalResults': totalResults,
        'books': books.map((e) => e.toJson()).toList(),
      };
}
