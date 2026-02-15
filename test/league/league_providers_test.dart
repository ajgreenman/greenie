import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/league/league_providers.dart';

void main() {
  group('League Providers', () {
    test('fetchLeaguesProvider returns leagues from fake repository', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final leagues = await container.read(fetchLeaguesProvider.future);
      expect(leagues, isNotEmpty);
    });

    test('fetchLeagueProvider returns a league by id', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final leagues = await container.read(fetchLeaguesProvider.future);
      final firstId = leagues.first.id;

      final league = await container.read(fetchLeagueProvider(firstId).future);
      expect(league.name, leagues.first.name);
    });

    test('fetchLeagueProvider throws for unknown id', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        () => container.read(fetchLeagueProvider('unknown').future),
        throwsStateError,
      );
    });
  });
}
