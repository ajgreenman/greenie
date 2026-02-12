import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/round/infrastructure/models/round_model.dart';
import 'package:greenie/round/infrastructure/models/round_status.dart';
import 'package:greenie/round/infrastructure/models/score_model.dart';

void main() {
  group('RoundModel', () {
    final round = RoundModel(
      id: 'r1',
      leagueId: 'l1',
      courseId: 'c1',
      date: DateTime(2025, 6, 1),
      status: RoundStatus.completed,
      holeNumbers: [1, 2, 3],
      scores: [
        const ScoreModel(memberId: 'm1', holeScores: {1: 4, 2: 3, 3: 5}),
      ],
    );

    test('stores all fields', () {
      expect(round.id, 'r1');
      expect(round.leagueId, 'l1');
      expect(round.courseId, 'c1');
      expect(round.date, DateTime(2025, 6, 1));
      expect(round.status, RoundStatus.completed);
      expect(round.holeNumbers, [1, 2, 3]);
      expect(round.scores.length, 1);
    });

    test('copyWith replaces status', () {
      final updated = round.copyWith(status: RoundStatus.inProgress);
      expect(updated.status, RoundStatus.inProgress);
      expect(updated.id, round.id);
      expect(updated.scores, round.scores);
    });

    test('copyWith replaces scores', () {
      final newScores = [
        const ScoreModel(memberId: 'm2', holeScores: {1: 5}),
      ];
      final updated = round.copyWith(scores: newScores);
      expect(updated.scores, newScores);
      expect(updated.status, round.status);
    });

    test('copyWith with no args returns equivalent round', () {
      final updated = round.copyWith();
      expect(updated.id, round.id);
      expect(updated.status, round.status);
      expect(updated.scores, round.scores);
    });
  });
}
