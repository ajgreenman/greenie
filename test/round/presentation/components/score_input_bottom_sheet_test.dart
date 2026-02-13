import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/theme.dart';
import 'package:greenie/round/presentation/components/score_input_bottom_sheet.dart';

Widget _buildTestApp(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      theme: buildLightTheme(),
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  group('ScoreInputBottomSheet', () {
    testWidgets('displays hole number', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          ScoreInputBottomSheet(
            holeNumber: 5,
            currentScore: null,
            onScoreSelected: (_) {},
          ),
        ),
      );
      expect(find.text('Hole 5'), findsOneWidget);
    });

    testWidgets('shows ChoiceChips for scores 1-10', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          ScoreInputBottomSheet(
            holeNumber: 1,
            currentScore: null,
            onScoreSelected: (_) {},
          ),
        ),
      );
      for (var i = 1; i <= 10; i++) {
        expect(find.text('$i'), findsOneWidget);
      }
    });

    testWidgets('highlights current score', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          ScoreInputBottomSheet(
            holeNumber: 1,
            currentScore: 4,
            onScoreSelected: (_) {},
          ),
        ),
      );
      final chip = tester.widget<ChoiceChip>(
        find.ancestor(of: find.text('4'), matching: find.byType(ChoiceChip)),
      );
      expect(chip.selected, true);
    });

    testWidgets('calls onScoreSelected when chip tapped', (tester) async {
      int? selectedScore;
      await tester.pumpWidget(
        _buildTestApp(
          ScoreInputBottomSheet(
            holeNumber: 1,
            currentScore: null,
            onScoreSelected: (s) => selectedScore = s,
          ),
        ),
      );
      await tester.tap(find.text('7'));
      expect(selectedScore, 7);
    });
  });
}
