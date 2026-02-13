import 'package:flutter/material.dart';
import 'package:greenie/app/core/design_constants.dart';

class ScorecardRow extends StatelessWidget {
  const ScorecardRow({
    super.key,
    required this.label,
    required this.cells,
    this.totalWidget,
  });

  final String label;
  final List<Widget> cells;
  final Widget? totalWidget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        SizedBox(
          width: scorecardLabelWidth,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: extraSmall),
            child: Text(
              label,
              style: theme.textTheme.labelSmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        ...cells,
        if (totalWidget != null)
          Container(
            width: scorecardTotalWidth,
            height: scoreCellSize,
            alignment: Alignment.center,
            child: totalWidget,
          ),
      ],
    );
  }
}
