import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/theme.dart';

void main() {
  group('buildLightTheme', () {
    test('returns ThemeData with light brightness', () {
      final theme = buildLightTheme();
      expect(theme.brightness, Brightness.light);
    });

    test('includes GreenieScoreColors extension', () {
      final theme = buildLightTheme();
      final ext = theme.extension<GreenieScoreColors>();
      expect(ext, isNotNull);
      expect(ext, equals(GreenieScoreColors.light));
    });

    test('uses Material 3', () {
      final theme = buildLightTheme();
      expect(theme.useMaterial3, true);
    });
  });

  group('buildDarkTheme', () {
    test('returns ThemeData with dark brightness', () {
      final theme = buildDarkTheme();
      expect(theme.brightness, Brightness.dark);
    });

    test('includes GreenieScoreColors extension', () {
      final theme = buildDarkTheme();
      final ext = theme.extension<GreenieScoreColors>();
      expect(ext, isNotNull);
      expect(ext, equals(GreenieScoreColors.dark));
    });
  });

  group('GreenieScoreColors', () {
    test('copyWith replaces specified colors', () {
      const colors = GreenieScoreColors.light;
      final copied = colors.copyWith(eagle: const Color(0xFF000000));
      expect(copied.eagle, const Color(0xFF000000));
      expect(copied.birdie, colors.birdie);
    });

    test('copyWith with no args returns same colors', () {
      const colors = GreenieScoreColors.light;
      final copied = colors.copyWith();
      expect(copied.eagle, colors.eagle);
      expect(copied.birdie, colors.birdie);
      expect(copied.par, colors.par);
      expect(copied.bogey, colors.bogey);
      expect(copied.doubleBogey, colors.doubleBogey);
      expect(copied.triplePlus, colors.triplePlus);
    });

    test('lerp interpolates between two color sets', () {
      const light = GreenieScoreColors.light;
      const dark = GreenieScoreColors.dark;
      final lerped = light.lerp(dark, 0.5);
      expect(lerped.eagle, isNotNull);
      // At t=0 should equal light
      final atZero = light.lerp(dark, 0.0);
      expect(atZero.eagle, light.eagle);
      // At t=1 should equal dark
      final atOne = light.lerp(dark, 1.0);
      expect(atOne.eagle, dark.eagle);
    });

    test('lerp with non-GreenieScoreColors returns this', () {
      const colors = GreenieScoreColors.light;
      final result = colors.lerp(null, 0.5);
      expect(result, colors);
    });
  });
}
