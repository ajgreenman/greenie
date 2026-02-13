import 'package:flutter/material.dart';
import 'package:greenie/app/core/design_constants.dart';

class HoleHeaderCell extends StatelessWidget {
  const HoleHeaderCell({super.key, required this.holeNumber});

  final int holeNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: scoreCellSize,
      height: scoreCellSize,
      alignment: Alignment.center,
      child: Text(
        '$holeNumber',
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
