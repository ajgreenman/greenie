import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/league/infrastructure/fake_league_repository.dart';

void main() {
  late FakeLeagueRepository repo;

  setUp(() {
    repo = FakeLeagueRepository();
  });

  group('FakeLeagueRepository', () {
    test('fetchLeagues returns at least 1 league', () async {
      final leagues = await repo.fetchLeagues();
      expect(leagues.isNotEmpty, true);
    });

    test('fetchLeague returns existing league by id', () async {
      final league = await repo.fetchLeague('league-1');
      expect(league, isNotNull);
      expect(league!.name, 'Wednesday Amateur Players (WAP)');
    });

    test('fetchLeague returns null for unknown id', () async {
      final league = await repo.fetchLeague('unknown');
      expect(league, isNull);
    });

    test('league has memberIds and adminId', () async {
      final league = await repo.fetchLeague('league-1');
      expect(league!.memberIds.isNotEmpty, true);
      expect(league.adminId, isNotEmpty);
    });
  });
}
