import 'package:flutter/material.dart';

class ScorecardTotals extends StatelessWidget {
  const ScorecardTotals({super.key, required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$total',
      style: Theme.of(
        context,
      ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
