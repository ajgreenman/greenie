import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/round/infrastructure/models/score_model.dart';

void main() {
  group('ScoreModel', () {
    test('totalStrokes sums all hole scores', () {
      const score = ScoreModel(memberId: 'm1', holeScores: {1: 4, 2: 3, 3: 5});
      expect(score.totalStrokes, 12);
    });

    test('totalStrokes is zero for empty scores', () {
      const score = ScoreModel(memberId: 'm1', holeScores: {});
      expect(score.totalStrokes, 0);
    });
  });
}
