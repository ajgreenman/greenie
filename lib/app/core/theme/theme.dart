import 'package:flutter/material.dart';

import 'package:greenie/app/core/theme/colors.dart';
import 'package:greenie/app/core/theme/sizes.dart';

/// Light and dark [ThemeData] for the app.
class GreenieTheme {
  GreenieTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: GreenieColors.greenPrimary,
      brightness: Brightness.light,
    );
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: GreenieColors.fairwayGreen,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1,
        clipBehavior: Clip.antiAlias,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: GreenieColors.teeBoxGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: GreenieSizes.extraLarge,
            vertical: GreenieSizes.large,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(GreenieSizes.large),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: GreenieSizes.large),
      ),
    );
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: GreenieColors.greenPrimary,
      brightness: Brightness.dark,
    );
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF0D3311),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: colorScheme.surface,
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1,
        clipBehavior: Clip.antiAlias,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF43A047),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: GreenieSizes.extraLarge,
            vertical: GreenieSizes.large,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(GreenieSizes.large),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: GreenieSizes.large),
      ),
    );
  }
}
