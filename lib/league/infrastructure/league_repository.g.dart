// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'league_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(leagueRepository)
const leagueRepositoryProvider = LeagueRepositoryProvider._();

final class LeagueRepositoryProvider
    extends
        $FunctionalProvider<
          LeagueRepository,
          LeagueRepository,
          LeagueRepository
        >
    with $Provider<LeagueRepository> {
  const LeagueRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'leagueRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$leagueRepositoryHash();

  @$internal
  @override
  $ProviderElement<LeagueRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LeagueRepository create(Ref ref) {
    return leagueRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LeagueRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LeagueRepository>(value),
    );
  }
}

String _$leagueRepositoryHash() => r'eeecf63d31afdee6a9714f0cbc120185d44a40b4';
