import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';

// Провайдер для списка категорий (книг)
final booksProvider = Provider<List<BookCategory>>((ref) {
  return [
    BookCategory('Departures', 16, 'assets/categories/dessert.png'),
    BookCategory('Behind Five Willows', 20, 'assets/categories/vegetarian.png'),
    BookCategory('The Place Between', 21, 'assets/categories/burger.png'),
    BookCategory('Time\'s Charm', 16, 'assets/categories/asian.png'),
    BookCategory('Enormous Wings', 18, 'assets/categories/italian.png'),
    BookCategory('Climate Wayfinding', 15, 'assets/categories/mexican.png'),
    BookCategory('Pay Attention To Me', 14, 'assets/categories/seafood.png'),
    BookCategory('Vast Enterprise', 19, 'assets/categories/pizza.png'),
    BookCategory('Only You', 15, 'assets/categories/sushi.png'),
    BookCategory('The Secret World', 22, 'assets/categories/coffee.png'),
    BookCategory('Hidden Path', 23, 'assets/categories/fast_food.png'),
    BookCategory('Midnight Sun', 18, 'assets/categories/salad.png'),
  ];
});

// Провайдер для избранных книг (Favorited)
final favoritesProvider = StateProvider<List<String>>((ref) => []);
