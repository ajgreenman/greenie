import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:greenie/app/core/app_providers.dart';
import 'package:greenie/app/core/routing.dart';
import 'package:greenie/app/core/theme/theme.dart';

void bootstrap({
  required List<Override> overrides,
  List<ProviderObserver> observers = const [],
  Widget? devOverlay,
}) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      overrides: overrides,
      observers: observers,
      child: App(devOverlay: devOverlay),
    ),
  );
}

class App extends ConsumerWidget {
  const App({super.key, this.devOverlay});

  /// When non-null, rendered as a floating overlay on top of every screen.
  /// Only passed in dev builds — prod always passes null.
  final Widget? devOverlay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Greenie',
      theme: GreenieTheme.light,
      darkTheme: GreenieTheme.dark,
      themeMode: ref.watch(themeModeProvider),
      routerConfig: ref.watch(routerProvider),
      builder: devOverlay != null
          ? (context, child) => Stack(
                fit: StackFit.expand,
                children: [
                  child ?? const SizedBox.shrink(),
                  devOverlay!,
                ],
              )
          : null,
    );
  }
}
