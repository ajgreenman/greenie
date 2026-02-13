import 'package:flutter/material.dart';
import 'package:greenie/app/core/design_constants.dart';

class StartRoundButton extends StatelessWidget {
  const StartRoundButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: extraSmall,
        children: [Text(label), const Icon(Icons.chevron_right)],
      ),
    );
  }
}
