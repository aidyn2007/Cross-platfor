class BookTag {
  final int? id;
  final int? bookId;
  final String? name;
  final double? amount;

  const BookTag({
    this.id,
    this.bookId,
    this.name,
    this.amount,
  });

  factory BookTag.fromJson(Map<String, dynamic> json) => BookTag(
        id: json['id'] as int?,
        bookId: json['bookId'] as int?,
        name: json['name'] as String?,
        amount: (json['amount'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'bookId': bookId,
        'name': name,
        'amount': amount,
      };

  BookTag copyWith({
    int? id,
    int? bookId,
    String? name,
    double? amount,
  }) {
    return BookTag(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      name: name ?? this.name,
      amount: amount ?? this.amount,
    );
  }
}
