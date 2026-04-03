import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Logs all Riverpod provider lifecycle events in debug mode.
final class ProviderLogger extends ProviderObserver {
  const ProviderLogger();

  static String _name(ProviderObserverContext context) =>
      context.provider.toString();

  static String _fmt(Object? value) {
    if (value == null) return 'null';
    final s = value.toString();
    // Truncate large values (e.g. full list dumps)
    return s.length > 120 ? '${s.substring(0, 120)}…' : s;
  }

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    debugPrint('[Riverpod] ADD    ${_name(context)} → ${_fmt(value)}');
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    debugPrint('[Riverpod] UPDATE ${_name(context)} → ${_fmt(newValue)}');
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    debugPrint('[Riverpod] DISP   ${_name(context)}');
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    debugPrint('[Riverpod] ERROR  ${_name(context)}: $error');
    debugPrint(stackTrace.toString());
  }
}
