import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/theme/theme.dart';
import 'package:greenie/course/presentation/components/scorecard_totals.dart';

Widget _buildTestApp(Widget child) {
  return ProviderScope(
    child: MaterialApp(theme: GreenieTheme.light, home: child),
  );
}

void main() {
  group('ScorecardTotals', () {
    testWidgets('displays total number', (tester) async {
      await tester.pumpWidget(_buildTestApp(const ScorecardTotals(total: 42)));
      expect(find.text('42'), findsOneWidget);
    });
  });
}
