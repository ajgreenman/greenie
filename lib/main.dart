import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenie/app/core/routing.dart';
import 'package:greenie/app/core/theme/theme.dart';

void main() {
  runApp(const ProviderScope(child: _App()));
}

class _App extends ConsumerWidget {
  const _App();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Greenie',
      theme: GreenieTheme.light,
      darkTheme: GreenieTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
