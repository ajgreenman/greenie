import 'package:flutter/material.dart';

class ScoreInputBottomSheet extends StatelessWidget {
  const ScoreInputBottomSheet({
    super.key,
    required this.holeNumber,
    required this.currentScore,
    required this.onScoreSelected,
  });

  final int holeNumber;
  final int? currentScore;
  final ValueChanged<int> onScoreSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hole $holeNumber', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(10, (i) {
              final score = i + 1;
              final isSelected = currentScore == score;
              return ChoiceChip(
                label: Text('$score'),
                selected: isSelected,
                onSelected: (_) {
                  onScoreSelected(score);
                  Navigator.of(context).pop();
                },
              );
            }),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
