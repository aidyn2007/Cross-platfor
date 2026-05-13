import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:yummy/ui/widgets/ingredient_card.dart';

Widget _buildWrappedWidget(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: ListView(
        children: [
          child,
        ],
      ),
    ),
  );
}

void main() {
  const mockIngredientName = 'colby jack cheese';
  group('IngredientCard', () {
    testWidgets('can build', (tester) async {
      await tester.pumpWidget(
        _buildWrappedWidget(IngredientCard(
          name: mockIngredientName,
          initiallyChecked: false,
          evenRow: true,
          showCheckbox: true,
          onChecked: (isChecked) {},
        )),
      );

      final cardFinder = find.byType(IngredientCard);
      final titleFinder = find.text(mockIngredientName);

      expect(cardFinder, findsOneWidget);
      expect(titleFinder, findsOneWidget);
    });

    testWidgets('can be checked when tapped', (tester) async {
      var isChecked = false;
      await tester.pumpWidget(
        _buildWrappedWidget(IngredientCard(
          name: mockIngredientName,
          initiallyChecked: isChecked,
          evenRow: true,
          showCheckbox: true,
          onChecked: (newValue) {
            isChecked = newValue;
          },
        )),
      );

      final checkboxFinder = find.byType(Checkbox);

      await tester.tap(checkboxFinder);
      await tester.pumpAndSettle();

      expect(isChecked, isTrue);
    });
  });

  group('Golden Tests - IngredientCard', () {
    testGoldens('can support light theme', (tester) async {
      final builder = GoldenBuilder.grid(columns: 2, widthToHeightRatio: 1)
        ..addScenario(
          'Light - Unchecked',
          IngredientCard(
            name: mockIngredientName,
            initiallyChecked: false,
            evenRow: true,
            showCheckbox: true,
            onChecked: (newValue) {},
          ),
        )
        ..addScenario(
          'Light - Checked',
          IngredientCard(
            name: mockIngredientName,
            initiallyChecked: true,
            evenRow: true,
            showCheckbox: true,
            onChecked: (newValue) {},
          ),
        )
        ..addScenario(
          'Light - Odd - Unchecked',
          IngredientCard(
            name: mockIngredientName,
            initiallyChecked: false,
            evenRow: false,
            showCheckbox: true,
            onChecked: (newValue) {},
          ),
        )
        ..addScenario(
          'Light - Odd - Checked',
          IngredientCard(
            name: mockIngredientName,
            initiallyChecked: true,
            evenRow: false,
            showCheckbox: true,
            onChecked: (newValue) {},
          ),
        );
      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
        ),
      );
      await screenMatchesGolden(tester, 'light_ingredient_card');
    });
  });
}
