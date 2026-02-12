// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'round_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fetchRoundsForLeague)
const fetchRoundsForLeagueProvider = FetchRoundsForLeagueFamily._();

final class FetchRoundsForLeagueProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RoundModel>>,
          List<RoundModel>,
          FutureOr<List<RoundModel>>
        >
    with $FutureModifier<List<RoundModel>>, $FutureProvider<List<RoundModel>> {
  const FetchRoundsForLeagueProvider._({
    required FetchRoundsForLeagueFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'fetchRoundsForLeagueProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$fetchRoundsForLeagueHash();

  @override
  String toString() {
    return r'fetchRoundsForLeagueProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<RoundModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RoundModel>> create(Ref ref) {
    final argument = this.argument as String;
    return fetchRoundsForLeague(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchRoundsForLeagueProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fetchRoundsForLeagueHash() =>
    r'0f2b4055562a74861f886ff964be110d470442cc';

final class FetchRoundsForLeagueFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<RoundModel>>, String> {
  const FetchRoundsForLeagueFamily._()
    : super(
        retry: null,
        name: r'fetchRoundsForLeagueProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FetchRoundsForLeagueProvider call(String leagueId) =>
      FetchRoundsForLeagueProvider._(argument: leagueId, from: this);

  @override
  String toString() => r'fetchRoundsForLeagueProvider';
}

@ProviderFor(fetchRound)
const fetchRoundProvider = FetchRoundFamily._();

final class FetchRoundProvider
    extends
        $FunctionalProvider<
          AsyncValue<RoundModel?>,
          RoundModel?,
          FutureOr<RoundModel?>
        >
    with $FutureModifier<RoundModel?>, $FutureProvider<RoundModel?> {
  const FetchRoundProvider._({
    required FetchRoundFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'fetchRoundProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$fetchRoundHash();

  @override
  String toString() {
    return r'fetchRoundProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<RoundModel?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RoundModel?> create(Ref ref) {
    final argument = this.argument as String;
    return fetchRound(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchRoundProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fetchRoundHash() => r'415e51a4344732b0a45b2164f411e849e65cde09';

final class FetchRoundFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<RoundModel?>, String> {
  const FetchRoundFamily._()
    : super(
        retry: null,
        name: r'fetchRoundProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FetchRoundProvider call(String roundId) =>
      FetchRoundProvider._(argument: roundId, from: this);

  @override
  String toString() => r'fetchRoundProvider';
}
