import 'package:flutter/material.dart';

class HoleHeaderCell extends StatelessWidget {
  const HoleHeaderCell({super.key, required this.holeNumber});

  final int holeNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
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
