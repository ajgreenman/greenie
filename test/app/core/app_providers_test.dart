import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/app_providers.dart';

void main() {
  group('ThemeModeNotifier', () {
    test('initial state is ThemeMode.system', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(themeModeProvider), ThemeMode.system);
    });

    test('setThemeMode updates state to light', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light);
      expect(container.read(themeModeProvider), ThemeMode.light);
    });

    test('setThemeMode updates state to dark', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
      expect(container.read(themeModeProvider), ThemeMode.dark);
    });

    test('setThemeMode can revert to system', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
      container.read(themeModeProvider.notifier).setThemeMode(ThemeMode.system);
      expect(container.read(themeModeProvider), ThemeMode.system);
    });
  });
}
