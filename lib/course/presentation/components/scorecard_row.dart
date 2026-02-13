import 'package:flutter/material.dart';
import 'package:greenie/app/core/theme.dart';

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
          width: 80,
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
            width: 44,
            height: 36,
            alignment: Alignment.center,
            child: totalWidget,
          ),
      ],
    );
  }
}
