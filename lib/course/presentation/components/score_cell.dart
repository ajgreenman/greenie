import 'package:flutter/material.dart';
import 'package:greenie/app/core/design_constants.dart';
import 'package:greenie/app/core/theme.dart';
import 'package:greenie/round/infrastructure/models/score_relative_to_par.dart';

class ScoreCell extends StatelessWidget {
  const ScoreCell({
    super.key,
    required this.score,
    required this.par,
    this.isEditable = false,
    this.onTap,
  });

  final int? score;
  final int par;
  final bool isEditable;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scoreColors = theme.extension<GreenieScoreColors>()!;

    if (score == null) {
      return GestureDetector(
        onTap: isEditable ? onTap : null,
        child: Container(
          width: scoreCellSize,
          height: scoreCellSize,
          alignment: Alignment.center,
          child: Text(
            '-',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ),
      );
    }

    final diff = score! - par;
    final relative = ScoreRelativeToPar.fromDifference(diff);
    final color = _colorForRelative(relative, scoreColors);
    final decoration = _decorationForRelative(relative, color);

    return GestureDetector(
      onTap: isEditable ? onTap : null,
      child: Container(
        width: scoreCellSize,
        height: scoreCellSize,
        alignment: Alignment.center,
        decoration: decoration,
        child: Text(
          '$score',
          style: theme.textTheme.bodySmall?.copyWith(
            color: _textColor(relative, color, theme),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Color _colorForRelative(
    ScoreRelativeToPar relative,
    GreenieScoreColors colors,
  ) {
    return switch (relative) {
      ScoreRelativeToPar.eagle => colors.eagle,
      ScoreRelativeToPar.birdie => colors.birdie,
      ScoreRelativeToPar.par => colors.par,
      ScoreRelativeToPar.bogey => colors.bogey,
      ScoreRelativeToPar.doubleBogey => colors.doubleBogey,
      ScoreRelativeToPar.triplePlus => colors.triplePlus,
    };
  }

  BoxDecoration? _decorationForRelative(
    ScoreRelativeToPar relative,
    Color color,
  ) {
    return switch (relative) {
      ScoreRelativeToPar.eagle => BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
        color: color.withValues(alpha: 0.15),
      ),
      ScoreRelativeToPar.birdie => BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      ScoreRelativeToPar.par => null,
      ScoreRelativeToPar.bogey => BoxDecoration(
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      ScoreRelativeToPar.doubleBogey => BoxDecoration(
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(4),
        color: color.withValues(alpha: 0.15),
      ),
      ScoreRelativeToPar.triplePlus => BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    };
  }

  Color _textColor(ScoreRelativeToPar relative, Color color, ThemeData theme) {
    if (relative == ScoreRelativeToPar.triplePlus) {
      return theme.colorScheme.onPrimary;
    }
    if (relative == ScoreRelativeToPar.par) {
      return theme.colorScheme.onSurface;
    }
    return color;
  }
}
