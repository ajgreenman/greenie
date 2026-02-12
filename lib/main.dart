import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenie/app/core/routing.dart';

void main() {
  runApp(ProviderScope(child: const _App()));
}

class _App extends ConsumerWidget {
  const _App();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Greenie',
      routerConfig: ref.watch(routerProvider),
    );
  }
}
