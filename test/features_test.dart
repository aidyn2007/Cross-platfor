import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:books/screens/account_page.dart';
import 'package:books/screens/book_details_page.dart';
import 'package:books/screens/personal_info_page.dart';
import 'package:books/providers.dart';
import 'package:books/models/models.dart' hide Book;
import 'package:books/models/book_category.dart';
import 'package:books/data/models/book.dart' as data;
import 'package:books/data/models/current_book_data.dart';
import 'package:books/data/repositories/memory_repository.dart';
import 'package:books/constants.dart';

// Тестовый репозиторий, который наследует MemoryRepository, 
// но НЕ инициализирует Firebase.
class TestRepository extends MemoryRepository {
  // Переопределяем конструктор, чтобы он не делал ничего лишнего
  TestRepository() : super();

  @override
  CurrentBookData build() {
    // Возвращаем пустое начальное состояние без подписок на Firebase
    return const CurrentBookData();
  }

  @override
  Future<int> insertBook(data.Book book) async {
    state = state.copyWith(currentBooks: [...state.currentBooks, book]);
    return 0;
  }

  @override
  void close() {}
}

void main() {
  late SharedPreferences sharedPreferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
  });

  group('Feature Tests: Points and Profile', () {
    final testUser = User(
      firstName: 'Test',
      lastName: 'User',
      role: 'Reader',
      profileImageUrl: '',
      points: 0,
      darkMode: false,
    );

    testWidgets('Adding a book increases points by 100 in AccountPage', (tester) async {
      final router = GoRouter(
        initialLocation: '/details',
        routes: [
          GoRoute(path: '/details', builder: (context, state) => BookDetailsPage(category: categories[0])),
          GoRoute(path: '/account', builder: (context, state) => AccountPage(user: testUser)),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPrefProvider.overrideWithValue(sharedPreferences),
            // Переопределяем на наш TestRepository
            repositoryProvider.overrideWith(() => TestRepository()),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );

      // 1. Добавляем книгу
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      // 2. Переходим в аккаунт
      router.go('/account');
      await tester.pumpAndSettle();

      // Проверяем баллы (1 книга * 100 = 100)
      expect(find.text('100 Points'), findsOneWidget);
    });

    testWidgets('Changing name in PersonalInfoPage updates AccountPage UI', (tester) async {
      final router = GoRouter(
        initialLocation: '/account',
        routes: [
          GoRoute(path: '/account', builder: (context, state) => AccountPage(user: testUser)),
          GoRoute(
            path: '/${BooksTab.account.value}/personal-info',
            builder: (context, state) => const PersonalInfoPage(),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPrefProvider.overrideWithValue(sharedPreferences),
            repositoryProvider.overrideWith(() => TestRepository()),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );

      // 1. Нажимаем на Personal Information
      await tester.tap(find.text('Personal Information'));
      await tester.pumpAndSettle();

      // 2. Вводим новое имя
      await tester.enterText(find.byType(TextField).at(0), 'John');
      await tester.enterText(find.byType(TextField).at(1), 'Doe');
      await tester.tap(find.text('Save Changes'));
      
      // Ждем сохранения и возврата назад
      await tester.pumpAndSettle();

      // 3. Проверяем результат
      expect(find.text('John Doe'), findsOneWidget);
    });
  });
}
