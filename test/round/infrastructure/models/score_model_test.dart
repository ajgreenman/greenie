import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/round/infrastructure/models/score_model.dart';

void main() {
  group('ScoreModel', () {
    test('totalStrokes sums all hole scores', () {
      const score = ScoreModel(
        memberId: 'm1',
        holeScores: {1: 4, 2: 3, 3: 5},
      );
      expect(score.totalStrokes, 12);
    });

    test('totalStrokes is zero for empty scores', () {
      const score = ScoreModel(memberId: 'm1', holeScores: {});
      expect(score.totalStrokes, 0);
    });

    test('copyWithHoleScore adds a new hole score', () {
      const score = ScoreModel(
        memberId: 'm1',
        holeScores: {1: 4, 2: 3},
      );
      final updated = score.copyWithHoleScore(3, 5);
      expect(updated.holeScores, {1: 4, 2: 3, 3: 5});
      expect(updated.memberId, 'm1');
    });

    test('copyWithHoleScore replaces existing hole score', () {
      const score = ScoreModel(
        memberId: 'm1',
        holeScores: {1: 4, 2: 3},
      );
      final updated = score.copyWithHoleScore(1, 6);
      expect(updated.holeScores[1], 6);
      expect(updated.holeScores[2], 3);
    });
  });
}
