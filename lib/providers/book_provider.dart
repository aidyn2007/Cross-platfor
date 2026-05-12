import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';

// Провайдер для списка категорий (книг)
final booksProvider = Provider<List<FoodCategory>>((ref) {
  return [
    FoodCategory('Departures', 16, 'assets/categories/dessert.png'),
    FoodCategory('Behind Five Willows', 20, 'assets/categories/vegetarian.png'),
    FoodCategory('The Place Between', 21, 'assets/categories/burger.png'),
    FoodCategory('Time\'s Charm', 16, 'assets/categories/asian.png'),
    FoodCategory('Enormous Wings', 18, 'assets/categories/italian.png'),
    FoodCategory('Climate Wayfinding', 15, 'assets/categories/mexican.png'),
    FoodCategory('Pay Attention To Me', 14, 'assets/categories/seafood.png'),
    FoodCategory('Vast Enterprise', 19, 'assets/categories/pizza.png'),
    FoodCategory('Only You', 15, 'assets/categories/sushi.png'),
    FoodCategory('The Secret World', 22, 'assets/categories/coffee.png'),
    FoodCategory('Hidden Path', 23, 'assets/categories/fast_food.png'),
    FoodCategory('Midnight Sun', 18, 'assets/categories/salad.png'),
  ];
});

// Провайдер для избранных книг (Favorited)
final favoritesProvider = StateProvider<List<String>>((ref) => []);
