// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dev_scenario_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DevScenarioNotifier)
const devScenarioProvider = DevScenarioNotifierProvider._();

final class DevScenarioNotifierProvider
    extends $NotifierProvider<DevScenarioNotifier, DevScenario> {
  const DevScenarioNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'devScenarioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$devScenarioNotifierHash();

  @$internal
  @override
  DevScenarioNotifier create() => DevScenarioNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DevScenario value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DevScenario>(value),
    );
  }
}

String _$devScenarioNotifierHash() =>
    r'7898da5ee79742a8f476fdd457d33da46b1eba21';

abstract class _$DevScenarioNotifier extends $Notifier<DevScenario> {
  DevScenario build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DevScenario, DevScenario>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DevScenario, DevScenario>,
              DevScenario,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
