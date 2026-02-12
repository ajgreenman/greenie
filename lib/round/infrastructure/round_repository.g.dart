// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'round_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(roundRepository)
const roundRepositoryProvider = RoundRepositoryProvider._();

final class RoundRepositoryProvider
    extends
        $FunctionalProvider<RoundRepository, RoundRepository, RoundRepository>
    with $Provider<RoundRepository> {
  const RoundRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roundRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roundRepositoryHash();

  @$internal
  @override
  $ProviderElement<RoundRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RoundRepository create(Ref ref) {
    return roundRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RoundRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RoundRepository>(value),
    );
  }
}

String _$roundRepositoryHash() => r'060b26304b681e68b4e7d42ece03d12ac77be3ac';
