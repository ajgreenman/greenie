import 'package:flutter/material.dart';
import 'package:greenie/app/core/theme/sizes.dart';

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
      padding: const EdgeInsets.all(GreenieSizes.large),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: GreenieSizes.medium),
            child: Text('Hole $holeNumber', style: theme.textTheme.titleMedium),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: GreenieSizes.large),
            child: Wrap(
              spacing: GreenieSizes.small,
              runSpacing: GreenieSizes.small,
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
          ),
        ],
      ),
    );
  }
}
