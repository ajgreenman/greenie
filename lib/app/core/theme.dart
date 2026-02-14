import 'package:flutter/material.dart';

// Brand colors
const fairwayGreen = Color(0xFF1B5E20);
const teeBoxGreen = Color(0xFF2E7D32);
// Spacing scale (shirt sizes, multiples of 4)
const extraSmall = 4.0;
const small = 8.0;
const medium = 12.0;
const large = 16.0;
const extraLarge = 24.0;

const _greenPrimary = Color(0xFF26BD00);

ThemeData buildLightTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: _greenPrimary,
    brightness: Brightness.light,
  );
  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    extensions: const [GreenieScoreColors.light],
    appBarTheme: const AppBarTheme(
      backgroundColor: fairwayGreen,
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
        backgroundColor: teeBoxGreen,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: extraLarge,
          vertical: large,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(large)),
      ),
    ),
    dividerTheme: DividerThemeData(
      thickness: 1,
      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
    ),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: large),
    ),
  );
}

ThemeData buildDarkTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: _greenPrimary,
    brightness: Brightness.dark,
  );
  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    brightness: Brightness.dark,
    extensions: const [GreenieScoreColors.dark],
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
          horizontal: extraLarge,
          vertical: large,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(large)),
      ),
    ),
    dividerTheme: DividerThemeData(
      thickness: 1,
      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
    ),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: large),
    ),
  );
}

class GreenieScoreColors extends ThemeExtension<GreenieScoreColors> {
  const GreenieScoreColors({
    required this.eagle,
    required this.birdie,
    required this.par,
    required this.bogey,
    required this.doubleBogey,
    required this.triplePlus,
  });

  final Color eagle;
  final Color birdie;
  final Color par;
  final Color bogey;
  final Color doubleBogey;
  final Color triplePlus;

  static const light = GreenieScoreColors(
    eagle: Color(0xFFFFD700),
    birdie: Color(0xFF2196F3),
    par: Color(0xFF4CAF50),
    bogey: Color(0xFFFF9800),
    doubleBogey: Color(0xFFF44336),
    triplePlus: Color(0xFF9C27B0),
  );

  static const dark = GreenieScoreColors(
    eagle: Color(0xFFFFD54F),
    birdie: Color(0xFF64B5F6),
    par: Color(0xFF81C784),
    bogey: Color(0xFFFFB74D),
    doubleBogey: Color(0xFFE57373),
    triplePlus: Color(0xFFCE93D8),
  );

  @override
  GreenieScoreColors copyWith({
    Color? eagle,
    Color? birdie,
    Color? par,
    Color? bogey,
    Color? doubleBogey,
    Color? triplePlus,
  }) {
    return GreenieScoreColors(
      eagle: eagle ?? this.eagle,
      birdie: birdie ?? this.birdie,
      par: par ?? this.par,
      bogey: bogey ?? this.bogey,
      doubleBogey: doubleBogey ?? this.doubleBogey,
      triplePlus: triplePlus ?? this.triplePlus,
    );
  }

  @override
  GreenieScoreColors lerp(GreenieScoreColors? other, double t) {
    if (other is! GreenieScoreColors) return this;
    return GreenieScoreColors(
      eagle: Color.lerp(eagle, other.eagle, t)!,
      birdie: Color.lerp(birdie, other.birdie, t)!,
      par: Color.lerp(par, other.par, t)!,
      bogey: Color.lerp(bogey, other.bogey, t)!,
      doubleBogey: Color.lerp(doubleBogey, other.doubleBogey, t)!,
      triplePlus: Color.lerp(triplePlus, other.triplePlus, t)!,
    );
  }
}
