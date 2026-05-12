class Ingredient {
  final int? id;
  final int? recipeId;
  final String? name;
  final double? amount;

  const Ingredient({
    this.id,
    this.recipeId,
    this.name,
    this.amount,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        id: json['id'] as int?,
        recipeId: json['recipeId'] as int?,
        name: json['name'] as String?,
        amount: (json['amount'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'recipeId': recipeId,
        'name': name,
        'amount': amount,
      };

  Ingredient copyWith({
    int? id,
    int? recipeId,
    String? name,
    double? amount,
  }) {
    return Ingredient(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      name: name ?? this.name,
      amount: amount ?? this.amount,
    );
  }
}
