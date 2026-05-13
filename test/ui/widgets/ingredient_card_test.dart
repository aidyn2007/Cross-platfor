import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:yummy/ui/widgets/tag_card.dart';

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
  const mockTagName = 'colby jack cheese';
  group('TagCard', () {
    testWidgets('can build', (tester) async {
      await tester.pumpWidget(
        _buildWrappedWidget(TagCard(
          name: mockTagName,
          initiallyChecked: false,
          evenRow: true,
          showCheckbox: true,
          onChecked: (isChecked) {},
        )),
      );

      final cardFinder = find.byType(TagCard);
      final titleFinder = find.text(mockTagName);

      expect(cardFinder, findsOneWidget);
      expect(titleFinder, findsOneWidget);
    });

    testWidgets('can be checked when tapped', (tester) async {
      var isChecked = false;
      await tester.pumpWidget(
        _buildWrappedWidget(TagCard(
          name: mockTagName,
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

  group('Golden Tests - TagCard', () {
    testGoldens('can support light theme', (tester) async {
      final builder = GoldenBuilder.grid(columns: 2, widthToHeightRatio: 1)
        ..addScenario(
          'Light - Unchecked',
          TagCard(
            name: mockTagName,
            initiallyChecked: false,
            evenRow: true,
            showCheckbox: true,
            onChecked: (newValue) {},
          ),
        )
        ..addScenario(
          'Light - Checked',
          TagCard(
            name: mockTagName,
            initiallyChecked: true,
            evenRow: true,
            showCheckbox: true,
            onChecked: (newValue) {},
          ),
        )
        ..addScenario(
          'Light - Odd - Unchecked',
          TagCard(
            name: mockTagName,
            initiallyChecked: false,
            evenRow: false,
            showCheckbox: true,
            onChecked: (newValue) {},
          ),
        )
        ..addScenario(
          'Light - Odd - Checked',
          TagCard(
            name: mockTagName,
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
      await screenMatchesGolden(tester, 'light_tag_card');
    });
  });
}
