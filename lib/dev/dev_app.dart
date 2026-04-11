import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenie/app/core/app_providers.dart';
import 'package:greenie/app/core/routing.dart';
import 'package:greenie/app/core/theme/theme.dart';
import 'package:greenie/dev/dev_menu.dart';

/// Dev-only variant of [App] that injects the scenario switcher FAB.
/// Uses [MaterialApp.router]'s builder to ensure the overlay has access
/// to the navigator (required for showModalBottomSheet).
class DevApp extends ConsumerWidget {
  const DevApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Greenie (Dev)',
      theme: GreenieTheme.light,
      darkTheme: GreenieTheme.dark,
      themeMode: ref.watch(themeModeProvider),
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) => Stack(
        children: [
          child ?? const SizedBox.shrink(),
          const DevMenuOverlay(),
        ],
      ),
    );
  }
}
