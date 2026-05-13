import 'book_tag.dart';

class Book {
  final int? id;
  final String? sourceId;
  final String? label;
  final String? image;
  final String? description;
  final bool bookmarked;
  final List<BookTag> tags;

  const Book({
    this.id,
    this.sourceId,
    this.label,
    this.image,
    this.description,
    this.bookmarked = false,
    this.tags = const <BookTag>[],
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json['id'] as int?,
        sourceId: json['sourceId'] as String?,
        label: json['label'] as String?,
        image: json['image'] as String?,
        description: json['description'] as String?,
        bookmarked: json['bookmarked'] as bool? ?? false,
        tags: (json['tags'] as List<dynamic>?)
                ?.map((e) => BookTag.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const <BookTag>[],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'sourceId': sourceId,
        'label': label,
        'image': image,
        'description': description,
        'bookmarked': bookmarked,
        'tags': tags.map((e) => e.toJson()).toList(),
      };

  Book copyWith({
    int? id,
    String? sourceId,
    String? label,
    String? image,
    String? description,
    bool? bookmarked,
    List<BookTag>? tags,
  }) {
    return Book(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      label: label ?? this.label,
      image: image ?? this.image,
      description: description ?? this.description,
      bookmarked: bookmarked ?? this.bookmarked,
      tags: tags ?? this.tags,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Book &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          label == other.label &&
          image == other.image &&
          description == other.description &&
          bookmarked == other.bookmarked;

  @override
  int get hashCode => Object.hash(id, label, image, description, bookmarked);
}
