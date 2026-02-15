import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/enums/golf_score.dart';

void main() {
  group('GolfScore', () {
    group('calculate', () {
      test('returns doubleAlbatross for score 0 par 5', () {
        expect(GolfScore.calculate(0, 5), GolfScore.doubleAlbatross);
      });

      test('returns doubleAlbatross for score 1 par 5', () {
        expect(GolfScore.calculate(1, 5), GolfScore.doubleAlbatross);
      });

      test('returns albatross for score 2 par 5', () {
        expect(GolfScore.calculate(2, 5), GolfScore.albatross);
      });

      test('returns eagle for score 3 par 5', () {
        expect(GolfScore.calculate(3, 5), GolfScore.eagle);
      });

      test('returns birdie for score 4 par 5', () {
        expect(GolfScore.calculate(4, 5), GolfScore.birdie);
      });

      test('returns par for score 5 par 5', () {
        expect(GolfScore.calculate(5, 5), GolfScore.par);
      });

      test('returns bogey for score 6 par 5', () {
        expect(GolfScore.calculate(6, 5), GolfScore.bogey);
      });

      test('returns doubleBogey for score 7 par 5', () {
        expect(GolfScore.calculate(7, 5), GolfScore.doubleBogey);
      });

      test('returns tripleBogey for score 8 par 5', () {
        expect(GolfScore.calculate(8, 5), GolfScore.tripleBogey);
      });

      test('returns plusFour for score 9 par 5', () {
        expect(GolfScore.calculate(9, 5), GolfScore.plusFour);
      });

      test('returns plusFive for score 10 par 5', () {
        expect(GolfScore.calculate(10, 5), GolfScore.plusFive);
      });

      test('returns plusFive for score 15 par 5', () {
        expect(GolfScore.calculate(15, 5), GolfScore.plusFive);
      });
    });

    group('displayName', () {
      test('doubleAlbatross', () {
        expect(GolfScore.doubleAlbatross.displayName, 'Double Albatross');
      });

      test('albatross', () {
        expect(GolfScore.albatross.displayName, 'Albatross');
      });

      test('eagle', () {
        expect(GolfScore.eagle.displayName, 'Eagle');
      });

      test('birdie', () {
        expect(GolfScore.birdie.displayName, 'Birdie');
      });

      test('par', () {
        expect(GolfScore.par.displayName, 'Par');
      });

      test('bogey', () {
        expect(GolfScore.bogey.displayName, 'Bogey');
      });

      test('doubleBogey', () {
        expect(GolfScore.doubleBogey.displayName, 'Double Bogey');
      });

      test('tripleBogey', () {
        expect(GolfScore.tripleBogey.displayName, 'Triple Bogey');
      });

      test('plusFour', () {
        expect(GolfScore.plusFour.displayName, 'Plus Four');
      });

      test('plusFive', () {
        expect(GolfScore.plusFive.displayName, 'Plus Five');
      });
    });

    group('color', () {
      test('light theme returns expected colors', () {
        expect(
          GolfScore.doubleAlbatross.color(
            ThemeData(brightness: Brightness.light),
          ),
          const Color(0xFF00BCD4),
        );
        expect(
          GolfScore.albatross.color(ThemeData(brightness: Brightness.light)),
          const Color(0xFFDAA520),
        );
        expect(
          GolfScore.eagle.color(ThemeData(brightness: Brightness.light)),
          const Color(0xFFFFD700),
        );
        expect(
          GolfScore.birdie.color(ThemeData(brightness: Brightness.light)),
          const Color(0xFF2196F3),
        );
        expect(
          GolfScore.par.color(ThemeData(brightness: Brightness.light)),
          const Color(0xFF4CAF50),
        );
        expect(
          GolfScore.bogey.color(ThemeData(brightness: Brightness.light)),
          const Color(0xFFFF9800),
        );
        expect(
          GolfScore.doubleBogey.color(ThemeData(brightness: Brightness.light)),
          const Color(0xFFF44336),
        );
        expect(
          GolfScore.tripleBogey.color(ThemeData(brightness: Brightness.light)),
          const Color(0xFF9C27B0),
        );
        expect(
          GolfScore.plusFour.color(ThemeData(brightness: Brightness.light)),
          const Color(0xFF7B1FA2),
        );
        expect(
          GolfScore.plusFive.color(ThemeData(brightness: Brightness.light)),
          const Color(0xFF4A148C),
        );
      });

      test('dark theme returns expected colors', () {
        expect(
          GolfScore.doubleAlbatross.color(
            ThemeData(brightness: Brightness.dark),
          ),
          const Color(0xFF4DD0E1),
        );
        expect(
          GolfScore.albatross.color(ThemeData(brightness: Brightness.dark)),
          const Color(0xFFE6C200),
        );
        expect(
          GolfScore.eagle.color(ThemeData(brightness: Brightness.dark)),
          const Color(0xFFFFD54F),
        );
        expect(
          GolfScore.birdie.color(ThemeData(brightness: Brightness.dark)),
          const Color(0xFF64B5F6),
        );
        expect(
          GolfScore.par.color(ThemeData(brightness: Brightness.dark)),
          const Color(0xFF81C784),
        );
        expect(
          GolfScore.bogey.color(ThemeData(brightness: Brightness.dark)),
          const Color(0xFFFFB74D),
        );
        expect(
          GolfScore.doubleBogey.color(ThemeData(brightness: Brightness.dark)),
          const Color(0xFFE57373),
        );
        expect(
          GolfScore.tripleBogey.color(ThemeData(brightness: Brightness.dark)),
          const Color(0xFFCE93D8),
        );
        expect(
          GolfScore.plusFour.color(ThemeData(brightness: Brightness.dark)),
          const Color(0xFFB39DDB),
        );
        expect(
          GolfScore.plusFive.color(ThemeData(brightness: Brightness.dark)),
          const Color(0xFF9575CD),
        );
      });
    });
  });
}
