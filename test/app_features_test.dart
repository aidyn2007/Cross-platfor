import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:books/screens/account_page.dart';
import 'package:books/screens/book_details_page.dart';
import 'package:books/screens/personal_info_page.dart';
import 'package:books/providers.dart';
import 'package:books/models/models.dart';
import 'package:books/models/book_category.dart';
import 'package:books/data/repositories/memory_repository.dart';
import 'package:books/data/models/current_book_data.dart';
import 'package:books/data/models/book.dart';

// Мок репозитория для тестирования без Firebase
class TestRepository extends MemoryRepository {
  @override
  CurrentBookData build() => const CurrentBookData();

  @override
  Future<int> insertBook(Book book) async {
    state = state.copyWith(currentBooks: [...state.currentBooks, book]);
    return 0;
  }
}

void main() {
  late SharedPreferences sharedPreferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
  });

  Widget createTestWidget(Widget child) {
    return ProviderScope(
      overrides: [
        sharedPrefProvider.overrideWithValue(sharedPreferences),
        repositoryProvider.overrideWith(() => TestRepository()),
      ],
      child: MaterialApp(
        home: child,
        // Определяем роуты для навигации
        onGenerateRoute: (settings) {
          if (settings.name == '/account/personal-info') {
            return MaterialPageRoute(builder: (_) => const PersonalInfoPage());
          }
          return null;
        },
      ),
    );
  }

  group('Тестирование основных функций приложения', () {
    final testUser = User(
      firstName: 'Ivan',
      lastName: 'Ivanov',
      role: 'Reader',
      profileImageUrl: '',
      points: 0,
      darkMode: false,
    );

    testWidgets('Добавление книги увеличивает баллы на 100', (tester) async {
      // 1. Загружаем страницу деталей книги
      final category = categories[0]; 
      await tester.pumpWidget(createTestWidget(BookDetailsPage(category: category)));

      // 2. Нажимаем кнопку добавления в библиотеку
      final addButton = find.byType(FilledButton);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // 3. Переключаемся на страницу аккаунта для проверки баллов
      await tester.pumpWidget(createTestWidget(AccountPage(user: testUser)));

      // Проверяем, что отображается "100 Points"
      expect(find.text('100 Points'), findsOneWidget);
    });

    testWidgets('Изменение имени в профиле отображается в аккаунте', (tester) async {
      // 1. Открываем страницу редактирования
      await tester.pumpWidget(createTestWidget(const PersonalInfoPage()));

      // 2. Вводим новые данные
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'Alex'); 
      await tester.enterText(textFields.at(1), 'Smith');

      // 3. Сохраняем
      await tester.tap(find.text('Save Changes'));
      await tester.pumpAndSettle();

      // 4. Проверяем результат на странице аккаунта
      await tester.pumpWidget(createTestWidget(AccountPage(user: testUser)));
      
      expect(find.text('Alex Smith'), findsOneWidget);
    });
  });
}
