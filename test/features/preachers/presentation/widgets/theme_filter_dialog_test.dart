import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plc/features/preachers/presentation/widgets/theme_filter_dialog.dart';

void main() {
  final tAvailableThemes = ['Fé', 'Esperança', 'Caridade', 'Oração'];
  final tSelectedThemes = ['Fé', 'Caridade'];

  testWidgets('should display all available themes', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ThemeFilterDialog(
          availableThemes: tAvailableThemes,
          selectedThemes: const [],
        ),
      ),
    );

    expect(find.text('Fé'), findsOneWidget);
    expect(find.text('Esperança'), findsOneWidget);
    expect(find.text('Caridade'), findsOneWidget);
    expect(find.text('Oração'), findsOneWidget);
  });

  testWidgets('should show selected themes as checked', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ThemeFilterDialog(
          availableThemes: tAvailableThemes,
          selectedThemes: tSelectedThemes,
        ),
      ),
    );

    final feCheckbox =
        tester.widget<CheckboxListTile>(find.byType(CheckboxListTile).at(0));
    final esperancaCheckbox =
        tester.widget<CheckboxListTile>(find.byType(CheckboxListTile).at(1));
    final caridadeCheckbox =
        tester.widget<CheckboxListTile>(find.byType(CheckboxListTile).at(2));

    expect(feCheckbox.value, true);
    expect(esperancaCheckbox.value, false);
    expect(caridadeCheckbox.value, true);
  });

  testWidgets('should toggle theme selection on tap', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ThemeFilterDialog(
          availableThemes: tAvailableThemes,
          selectedThemes: const [],
        ),
      ),
    );

    await tester.tap(find.text('Fé'));
    await tester.pump();

    final feCheckbox =
        tester.widget<CheckboxListTile>(find.byType(CheckboxListTile).at(0));
    expect(feCheckbox.value, true);
  });

  testWidgets('should clear all selections when clear button is pressed', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ThemeFilterDialog(
          availableThemes: tAvailableThemes,
          selectedThemes: tSelectedThemes,
        ),
      ),
    );

    await tester.tap(find.text('Limpar'));
    await tester.pump();

    final checkboxes = tester.widgetList<CheckboxListTile>(
      find.byType(CheckboxListTile),
    );
    for (final checkbox in checkboxes) {
      expect(checkbox.value, false);
    }
  });

  testWidgets('should return null when cancel button is pressed', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  final result = await showDialog<List<String>>(
                    context: context,
                    builder: (context) => ThemeFilterDialog(
                      availableThemes: tAvailableThemes,
                      selectedThemes: tSelectedThemes,
                    ),
                  );
                  expect(result, null);
                },
                child: const Text('Open Dialog'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
  });

  testWidgets('should return selected themes when apply button is pressed', (
    WidgetTester tester,
  ) async {
    List<String>? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await showDialog<List<String>>(
                    context: context,
                    builder: (context) => ThemeFilterDialog(
                      availableThemes: tAvailableThemes,
                      selectedThemes: tSelectedThemes,
                    ),
                  );
                },
                child: const Text('Open Dialog'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Aplicar'));
    await tester.pumpAndSettle();

    expect(result, tSelectedThemes);
  });
}
