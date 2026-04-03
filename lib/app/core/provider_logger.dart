import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Logs Riverpod provider lifecycle events in debug mode.
///
/// Filters out noisy framework providers (theme, router, scroll) to keep
/// logs focused on app-level state changes.
final class ProviderLogger extends ProviderObserver {
  const ProviderLogger();

  static const _noisy = {
    'themeModeProvider',
    'routerProvider',
    'scrollControllerProvider',
  };

  static bool _isNoisy(ProviderObserverContext context) {
    final name = context.provider.name ?? context.provider.runtimeType.toString();
    return _noisy.any((n) => name.contains(n));
  }

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
    if (_isNoisy(context)) return;
    debugPrint('[Riverpod] ADD    ${_name(context)} → ${_fmt(value)}');
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    if (_isNoisy(context)) return;
    debugPrint('[Riverpod] UPDATE ${_name(context)} → ${_fmt(newValue)}');
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    if (_isNoisy(context)) return;
    debugPrint('[Riverpod] DISP   ${_name(context)}');
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    // Always log errors, even noisy providers
    debugPrint('[Riverpod] ERROR  ${_name(context)}: $error');
    debugPrint(stackTrace.toString());
  }
}
