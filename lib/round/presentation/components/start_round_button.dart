import 'package:flutter/material.dart';

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
      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
      child: Text(label),
    );
  }
}
