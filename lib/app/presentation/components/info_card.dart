import 'package:flutter/material.dart';
import 'package:greenie/app/core/design_constants.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: large,
        vertical: extraSmall,
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: const EdgeInsets.all(large), child: child),
      ),
    );
  }
}
