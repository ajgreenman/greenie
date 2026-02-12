import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/round/infrastructure/models/score_relative_to_par.dart';

void main() {
  group('ScoreRelativeToPar', () {
    group('fromDifference', () {
      test('returns eagle for -3', () {
        expect(ScoreRelativeToPar.fromDifference(-3), ScoreRelativeToPar.eagle);
      });

      test('returns eagle for -2', () {
        expect(ScoreRelativeToPar.fromDifference(-2), ScoreRelativeToPar.eagle);
      });

      test('returns birdie for -1', () {
        expect(
          ScoreRelativeToPar.fromDifference(-1),
          ScoreRelativeToPar.birdie,
        );
      });

      test('returns par for 0', () {
        expect(ScoreRelativeToPar.fromDifference(0), ScoreRelativeToPar.par);
      });

      test('returns bogey for +1', () {
        expect(ScoreRelativeToPar.fromDifference(1), ScoreRelativeToPar.bogey);
      });

      test('returns doubleBogey for +2', () {
        expect(
          ScoreRelativeToPar.fromDifference(2),
          ScoreRelativeToPar.doubleBogey,
        );
      });

      test('returns triplePlus for +3', () {
        expect(
          ScoreRelativeToPar.fromDifference(3),
          ScoreRelativeToPar.triplePlus,
        );
      });

      test('returns triplePlus for +5', () {
        expect(
          ScoreRelativeToPar.fromDifference(5),
          ScoreRelativeToPar.triplePlus,
        );
      });
    });

    group('displayName', () {
      test('eagle', () {
        expect(ScoreRelativeToPar.eagle.displayName, 'Eagle');
      });

      test('birdie', () {
        expect(ScoreRelativeToPar.birdie.displayName, 'Birdie');
      });

      test('par', () {
        expect(ScoreRelativeToPar.par.displayName, 'Par');
      });

      test('bogey', () {
        expect(ScoreRelativeToPar.bogey.displayName, 'Bogey');
      });

      test('doubleBogey', () {
        expect(ScoreRelativeToPar.doubleBogey.displayName, 'Double Bogey');
      });

      test('triplePlus', () {
        expect(ScoreRelativeToPar.triplePlus.displayName, 'Triple+');
      });
    });
  });
}
