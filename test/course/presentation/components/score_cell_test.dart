import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/theme.dart';
import 'package:greenie/course/presentation/components/score_cell.dart';

Widget _buildTestApp(Widget child) {
  return ProviderScope(
    child: MaterialApp(theme: buildLightTheme(), home: child),
  );
}

void main() {
  group('ScoreCell', () {
    testWidgets('shows dash for null score', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(const ScoreCell(score: null, par: 4)),
      );
      expect(find.text('-'), findsOneWidget);
    });

    testWidgets('shows score number for par', (tester) async {
      await tester.pumpWidget(_buildTestApp(const ScoreCell(score: 4, par: 4)));
      expect(find.text('4'), findsOneWidget);
    });

    testWidgets('birdie score (par-1)', (tester) async {
      await tester.pumpWidget(_buildTestApp(const ScoreCell(score: 3, par: 4)));
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('eagle score (par-2)', (tester) async {
      await tester.pumpWidget(_buildTestApp(const ScoreCell(score: 2, par: 4)));
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('bogey score (par+1)', (tester) async {
      await tester.pumpWidget(_buildTestApp(const ScoreCell(score: 5, par: 4)));
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('double bogey score (par+2)', (tester) async {
      await tester.pumpWidget(_buildTestApp(const ScoreCell(score: 6, par: 4)));
      expect(find.text('6'), findsOneWidget);
    });

    testWidgets('triple+ score (par+3)', (tester) async {
      await tester.pumpWidget(_buildTestApp(const ScoreCell(score: 7, par: 4)));
      expect(find.text('7'), findsOneWidget);
    });

    testWidgets('tappable when editable', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _buildTestApp(
          ScoreCell(
            score: 4,
            par: 4,
            isEditable: true,
            onTap: () => tapped = true,
          ),
        ),
      );
      await tester.tap(find.text('4'));
      expect(tapped, true);
    });

    testWidgets('tappable null score when editable', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _buildTestApp(
          ScoreCell(
            score: null,
            par: 4,
            isEditable: true,
            onTap: () => tapped = true,
          ),
        ),
      );
      await tester.tap(find.text('-'));
      expect(tapped, true);
    });
  });
}
