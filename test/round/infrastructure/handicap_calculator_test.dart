import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/round/infrastructure/handicap_calculator.dart';

void main() {
  group('calculateHandicapStrokes', () {
    test('distributes evenly when divisible', () {
      final result = calculateHandicapStrokes(9, [1, 2, 3, 4, 5, 6, 7, 8, 9]);
      for (var i = 1; i <= 9; i++) {
        expect(result[i], 1);
      }
    });

    test('distributes extra strokes to earlier holes', () {
      final result = calculateHandicapStrokes(5, [1, 2, 3, 4, 5, 6, 7, 8, 9]);
      // 5 / 9 = 0 base + 5 extra
      expect(result[1], 1);
      expect(result[2], 1);
      expect(result[3], 1);
      expect(result[4], 1);
      expect(result[5], 1);
      expect(result[6], 0);
      expect(result[7], 0);
      expect(result[8], 0);
      expect(result[9], 0);
    });

    test('high handicap gives multiple strokes per hole', () {
      final result = calculateHandicapStrokes(20, [1, 2, 3, 4, 5, 6, 7, 8, 9]);
      // 20 / 9 = 2 base + 2 extra
      expect(result[1], 3);
      expect(result[2], 3);
      expect(result[3], 2);
    });

    test('zero handicap gives zero strokes', () {
      final result = calculateHandicapStrokes(0, [1, 2, 3]);
      expect(result[1], 0);
      expect(result[2], 0);
      expect(result[3], 0);
    });

    test('empty hole list returns empty map', () {
      final result = calculateHandicapStrokes(10, []);
      expect(result, isEmpty);
    });

    test('sorts hole numbers for consistent distribution', () {
      final result = calculateHandicapStrokes(2, [9, 1, 5]);
      // Sorted: [1, 5, 9]. 2 extra to first 2
      expect(result[1], 1);
      expect(result[5], 1);
      expect(result[9], 0);
    });
  });

  group('netScore', () {
    test('subtracts handicap strokes from gross', () {
      expect(netScore(5, 1), 4);
    });

    test('zero handicap strokes returns gross', () {
      expect(netScore(4, 0), 4);
    });
  });
}
