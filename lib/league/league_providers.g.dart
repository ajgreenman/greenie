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

@ProviderFor(fetchLeague)
const fetchLeagueProvider = FetchLeagueFamily._();

final class FetchLeagueProvider
    extends
        $FunctionalProvider<
          AsyncValue<LeagueModel?>,
          LeagueModel?,
          FutureOr<LeagueModel?>
        >
    with $FutureModifier<LeagueModel?>, $FutureProvider<LeagueModel?> {
  const FetchLeagueProvider._({
    required FetchLeagueFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'fetchLeagueProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$fetchLeagueHash();

  @override
  String toString() {
    return r'fetchLeagueProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<LeagueModel?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LeagueModel?> create(Ref ref) {
    final argument = this.argument as String;
    return fetchLeague(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchLeagueProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fetchLeagueHash() => r'2a0d1a7b5d918c7874008f0f85520a82fdafb2eb';

final class FetchLeagueFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<LeagueModel?>, String> {
  const FetchLeagueFamily._()
    : super(
        retry: null,
        name: r'fetchLeagueProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FetchLeagueProvider call(String leagueId) =>
      FetchLeagueProvider._(argument: leagueId, from: this);

  @override
  String toString() => r'fetchLeagueProvider';
}
