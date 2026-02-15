import 'package:flutter/material.dart';

/// Golf score types (relative to par).
enum GolfScore {
  doubleAlbatross,
  albatross,
  eagle,
  birdie,
  par,
  bogey,
  doubleBogey,
  tripleBogey,
  plusFour,
  plusFive;

  /// Calculates [GolfScore] from strokes and par.
  static GolfScore calculate(int score, int par) {
    final difference = score - par;
    if (difference <= -4) return GolfScore.doubleAlbatross;
    if (difference == -3) return GolfScore.albatross;
    if (difference == -2) return GolfScore.eagle;
    if (difference == -1) return GolfScore.birdie;
    if (difference == 0) return GolfScore.par;
    if (difference == 1) return GolfScore.bogey;
    if (difference == 2) return GolfScore.doubleBogey;
    if (difference == 3) return GolfScore.tripleBogey;
    if (difference == 4) return GolfScore.plusFour;
    return GolfScore.plusFive;
  }

  String get displayName {
    switch (this) {
      case GolfScore.doubleAlbatross:
        return 'Double Albatross';
      case GolfScore.albatross:
        return 'Albatross';
      case GolfScore.eagle:
        return 'Eagle';
      case GolfScore.birdie:
        return 'Birdie';
      case GolfScore.par:
        return 'Par';
      case GolfScore.bogey:
        return 'Bogey';
      case GolfScore.doubleBogey:
        return 'Double Bogey';
      case GolfScore.tripleBogey:
        return 'Triple Bogey';
      case GolfScore.plusFour:
        return 'Plus Four';
      case GolfScore.plusFive:
        return 'Plus Five';
    }
  }

  /// Returns the theme-appropriate color for this score.
  Color color(ThemeData theme) => theme.brightness == Brightness.dark
      ? _darkColors[this]!
      : _lightColors[this]!;

  /// Returns the decoration for a score cell, or null for par.
  BoxDecoration? decoration(ThemeData theme) {
    final color = this.color(theme);
    return switch (this) {
      GolfScore.doubleAlbatross ||
      GolfScore.albatross ||
      GolfScore.eagle => BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
        color: color.withValues(alpha: 0.15),
      ),
      GolfScore.birdie => BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      GolfScore.par => null,
      GolfScore.bogey => BoxDecoration(
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      GolfScore.doubleBogey => BoxDecoration(
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(4),
        color: color.withValues(alpha: 0.15),
      ),
      GolfScore.tripleBogey || GolfScore.plusFour || GolfScore.plusFive =>
        BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
    };
  }

  /// Returns the text color for a score cell.
  Color textColor(ThemeData theme) {
    final color = this.color(theme);
    if (this == GolfScore.tripleBogey ||
        this == GolfScore.plusFour ||
        this == GolfScore.plusFive) {
      return theme.colorScheme.onPrimary;
    }
    if (this == GolfScore.par) {
      return theme.colorScheme.onSurface;
    }
    return color;
  }

  static const Map<GolfScore, Color> _lightColors = {
    GolfScore.doubleAlbatross: Color(0xFF00BCD4),
    GolfScore.albatross: Color(0xFFDAA520),
    GolfScore.eagle: Color(0xFFFFD700),
    GolfScore.birdie: Color(0xFF2196F3),
    GolfScore.par: Color(0xFF4CAF50),
    GolfScore.bogey: Color(0xFFFF9800),
    GolfScore.doubleBogey: Color(0xFFF44336),
    GolfScore.tripleBogey: Color(0xFF9C27B0),
    GolfScore.plusFour: Color(0xFF7B1FA2),
    GolfScore.plusFive: Color(0xFF4A148C),
  };

  static const Map<GolfScore, Color> _darkColors = {
    GolfScore.doubleAlbatross: Color(0xFF4DD0E1),
    GolfScore.albatross: Color(0xFFE6C200),
    GolfScore.eagle: Color(0xFFFFD54F),
    GolfScore.birdie: Color(0xFF64B5F6),
    GolfScore.par: Color(0xFF81C784),
    GolfScore.bogey: Color(0xFFFFB74D),
    GolfScore.doubleBogey: Color(0xFFE57373),
    GolfScore.tripleBogey: Color(0xFFCE93D8),
    GolfScore.plusFour: Color(0xFFB39DDB),
    GolfScore.plusFive: Color(0xFF9575CD),
  };
}
