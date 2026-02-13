import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/round/infrastructure/models/score_model.dart';
import 'package:greenie/round/infrastructure/skins_calculator.dart';

void main() {
  group('calculateSkins', () {
    test('clear winner gets the skin', () {
      final scores = [
        const ScoreModel(memberId: 'm1', holeScores: {1: 3, 2: 4}),
        const ScoreModel(memberId: 'm2', holeScores: {1: 4, 2: 5}),
        const ScoreModel(memberId: 'm3', holeScores: {1: 5, 2: 6}),
      ];
      final skins = calculateSkins(scores, [1, 2]);
      expect(skins[1], 'm1');
      expect(skins[2], 'm1');
    });

    test('tie means no skin awarded', () {
      final scores = [
        const ScoreModel(memberId: 'm1', holeScores: {1: 4}),
        const ScoreModel(memberId: 'm2', holeScores: {1: 4}),
      ];
      final skins = calculateSkins(scores, [1]);
      expect(skins[1], isNull);
    });

    test('different winners on different holes', () {
      final scores = [
        const ScoreModel(memberId: 'm1', holeScores: {1: 3, 2: 5}),
        const ScoreModel(memberId: 'm2', holeScores: {1: 4, 2: 3}),
      ];
      final skins = calculateSkins(scores, [1, 2]);
      expect(skins[1], 'm1');
      expect(skins[2], 'm2');
    });

    test('empty scores yields null for each hole', () {
      final skins = calculateSkins([], [1, 2, 3]);
      expect(skins[1], isNull);
      expect(skins[2], isNull);
      expect(skins[3], isNull);
    });

    test('partial scores - only scored players compete', () {
      final scores = [
        const ScoreModel(memberId: 'm1', holeScores: {1: 4}),
        const ScoreModel(memberId: 'm2', holeScores: {1: 5, 2: 3}),
      ];
      final skins = calculateSkins(scores, [1, 2]);
      expect(skins[1], 'm1');
      expect(skins[2], 'm2');
    });

    test('three-way tie means no skin', () {
      final scores = [
        const ScoreModel(memberId: 'm1', holeScores: {1: 4}),
        const ScoreModel(memberId: 'm2', holeScores: {1: 4}),
        const ScoreModel(memberId: 'm3', holeScores: {1: 4}),
      ];
      final skins = calculateSkins(scores, [1]);
      expect(skins[1], isNull);
    });
  });
}
