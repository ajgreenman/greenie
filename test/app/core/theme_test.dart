import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/theme/theme.dart';

void main() {
  group('GreenieTheme.light getter', () {
    test('returns ThemeData with light brightness', () {
      final theme = GreenieTheme.light;
      expect(theme.brightness, Brightness.light);
    });

    test('uses Material 3', () {
      final theme = GreenieTheme.light;
      expect(theme.useMaterial3, true);
    });
  });

  group('GreenieTheme.dark getter', () {
    test('returns ThemeData with dark brightness', () {
      final theme = GreenieTheme.dark;
      expect(theme.brightness, Brightness.dark);
    });
  });
}
