import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/theme.dart';
import 'package:greenie/course/presentation/components/scorecard_row.dart';

Widget _buildTestApp(Widget child) {
  return ProviderScope(
    child: MaterialApp(theme: buildLightTheme(), home: child),
  );
}

void main() {
  group('ScorecardRow', () {
    testWidgets('displays label and cells', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          const ScorecardRow(
            label: 'Par',
            cells: [
              SizedBox(width: 36, child: Text('4')),
              SizedBox(width: 36, child: Text('3')),
            ],
          ),
        ),
      );
      expect(find.text('Par'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('displays total widget when provided', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          const ScorecardRow(label: 'Par', cells: [], totalWidget: Text('36')),
        ),
      );
      expect(find.text('36'), findsOneWidget);
    });
  });
}
