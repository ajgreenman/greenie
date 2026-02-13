import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/round/infrastructure/fake_round_repository.dart';
import 'package:greenie/round/infrastructure/models/round_status.dart';

void main() {
  late FakeRoundRepository repo;

  setUp(() {
    repo = FakeRoundRepository();
  });

  group('FakeRoundRepository', () {
    test('fetchRoundsForLeague returns rounds for league-1', () async {
      final rounds = await repo.fetchRoundsForLeague('league-1');
      expect(rounds.length, 6);
    });

    test('fetchRoundsForLeague returns empty for unknown league', () async {
      final rounds = await repo.fetchRoundsForLeague('unknown');
      expect(rounds, isEmpty);
    });

    test('fetchRound returns existing round', () async {
      final round = await repo.fetchRound('round-1');
      expect(round, isNotNull);
      expect(round!.id, 'round-1');
    });

    test('fetchRound returns null for unknown round', () async {
      final round = await repo.fetchRound('unknown');
      expect(round, isNull);
    });

    test('updateScore modifies existing score', () async {
      await repo.updateScore('round-1', 'member-1', {1: 10});
      final round = await repo.fetchRound('round-1');
      final score = round!.scores.firstWhere((s) => s.memberId == 'member-1');
      expect(score.holeScores[1], 10);
    });

    test('updateScore does nothing for unknown round', () async {
      await repo.updateScore('unknown', 'member-1', {1: 10});
      // No exception thrown
    });

    test('startRound changes status to inProgress', () async {
      final started = await repo.startRound('round-6');
      expect(started.status, RoundStatus.inProgress);

      final fetched = await repo.fetchRound('round-6');
      expect(fetched!.status, RoundStatus.inProgress);
    });

    test('startRound throws for unknown round', () async {
      expect(() => repo.startRound('unknown'), throwsA(isA<StateError>()));
    });

    test('contains completed, in-progress, and upcoming rounds', () async {
      final rounds = await repo.fetchRoundsForLeague('league-1');
      final statuses = rounds.map((r) => r.status).toSet();
      expect(statuses, contains(RoundStatus.completed));
      expect(statuses, contains(RoundStatus.inProgress));
      expect(statuses, contains(RoundStatus.upcoming));
    });
  });
}
