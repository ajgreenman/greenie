import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/app_providers.dart';
import 'package:greenie/app/core/theme/theme.dart';
import 'package:greenie/app/presentation/settings_screen.dart';

Widget _buildScreen() {
  return ProviderScope(
    child: MaterialApp(theme: GreenieTheme.light, home: const SettingsScreen()),
  );
}

void main() {
  group('SettingsScreen', () {
    testWidgets('shows Settings in app bar', (tester) async {
      await tester.pumpWidget(_buildScreen());
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('shows all three theme options', (tester) async {
      await tester.pumpWidget(_buildScreen());
      expect(find.text('System'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);
    });

    testWidgets('shows Appearance section header', (tester) async {
      await tester.pumpWidget(_buildScreen());
      expect(find.text('Appearance'), findsOneWidget);
    });

    testWidgets('selecting Light updates theme mode provider', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: GreenieTheme.light,
            home: const SettingsScreen(),
          ),
        ),
      );

      await tester.tap(find.text('Light'));
      await tester.pump();

      expect(container.read(themeModeProvider), ThemeMode.light);
    });

    testWidgets('selecting Dark updates theme mode provider', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: GreenieTheme.light,
            home: const SettingsScreen(),
          ),
        ),
      );

      await tester.tap(find.text('Dark'));
      await tester.pump();

      expect(container.read(themeModeProvider), ThemeMode.dark);
    });
  });
}
