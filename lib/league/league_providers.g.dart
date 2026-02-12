// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'league_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fetchLeagues)
const fetchLeaguesProvider = FetchLeaguesProvider._();

final class FetchLeaguesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LeagueModel>>,
          List<LeagueModel>,
          FutureOr<List<LeagueModel>>
        >
    with
        $FutureModifier<List<LeagueModel>>,
        $FutureProvider<List<LeagueModel>> {
  const FetchLeaguesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fetchLeaguesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fetchLeaguesHash();

  @$internal
  @override
  $FutureProviderElement<List<LeagueModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LeagueModel>> create(Ref ref) {
    return fetchLeagues(ref);
  }
}

String _$fetchLeaguesHash() => r'7c051f4139276fbc1591ef9feb9ce2147b89997f';
