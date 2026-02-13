import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/round/round_providers.dart';

void main() {
  group('Round Providers', () {
    test('fetchRoundsForLeagueProvider returns rounds', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final rounds = await container.read(
        fetchRoundsForLeagueProvider('league-1').future,
      );
      expect(rounds, isNotEmpty);
    });

    test('fetchRoundProvider returns a round by id', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final rounds = await container.read(
        fetchRoundsForLeagueProvider('league-1').future,
      );
      final firstId = rounds.first.id;

      final round = await container.read(fetchRoundProvider(firstId).future);
      expect(round, isNotNull);
    });

    test('fetchRoundProvider returns null for unknown id', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final round = await container.read(fetchRoundProvider('unknown').future);
      expect(round, isNull);
    });
  });
}
