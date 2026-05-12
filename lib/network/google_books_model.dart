import 'package:yummy/data/models/models.dart';

class GoogleBooksResults {
  final List<GoogleBook>? items;
  final int totalItems;

  GoogleBooksResults({this.items, required this.totalItems});

  factory GoogleBooksResults.fromJson(Map<String, dynamic> json) =>
      GoogleBooksResults(
        items: (json['items'] as List<dynamic>?)
            ?.map((e) => GoogleBook.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalItems: json['totalItems'] as int? ?? 0,
      );
}

class GoogleBook {
  final String id;
  final VolumeInfo volumeInfo;

  GoogleBook({required this.id, required this.volumeInfo});

  factory GoogleBook.fromJson(Map<String, dynamic> json) => GoogleBook(
        id: json['id'] as String,
        volumeInfo:
            VolumeInfo.fromJson(json['volumeInfo'] as Map<String, dynamic>),
      );
}

class VolumeInfo {
  final String? title;
  final String? description;
  final ImageLinks? imageLinks;

  VolumeInfo({this.title, this.description, this.imageLinks});

  factory VolumeInfo.fromJson(Map<String, dynamic> json) => VolumeInfo(
        title: json['title'] as String?,
        description: json['description'] as String?,
        imageLinks: json['imageLinks'] != null
            ? ImageLinks.fromJson(json['imageLinks'] as Map<String, dynamic>)
            : null,
      );
}

class ImageLinks {
  final String? thumbnail;

  ImageLinks({this.thumbnail});

  factory ImageLinks.fromJson(Map<String, dynamic> json) => ImageLinks(
        thumbnail: json['thumbnail'] as String?,
      );
}

Recipe googleBookToRecipe(GoogleBook book) {
  return Recipe(
    id: book.id.hashCode,
    sourceId: book.id,
    label: book.volumeInfo.title ?? 'No Title',
    image: book.volumeInfo.imageLinks?.thumbnail?.replaceAll('http:', 'https:'),
    description: book.volumeInfo.description ?? 'No description available.',
    bookmarked: false,
    ingredients: [],
  );
}
