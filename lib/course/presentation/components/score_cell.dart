import 'package:flutter/material.dart';
import 'package:greenie/app/core/enums/golf_score.dart';

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
    if (score == null) {
      return GestureDetector(
        onTap: isEditable ? onTap : null,
        child: Container(
          width: 36,
          height: 36,
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

    final golfScore = GolfScore.calculate(score!, par);

    return GestureDetector(
      onTap: isEditable ? onTap : null,
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: golfScore.decoration(theme),
        child: Text(
          '$score',
          style: theme.textTheme.bodySmall?.copyWith(
            color: golfScore.textColor(theme),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
