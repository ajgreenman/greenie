import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/theme.dart';
import 'package:greenie/round/presentation/components/start_round_button.dart';

Widget _buildTestApp(Widget child) {
  return ProviderScope(
    child: MaterialApp(theme: buildLightTheme(), home: child),
  );
}

void main() {
  group('StartRoundButton', () {
    testWidgets('displays label', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(StartRoundButton(label: 'Start Round', onPressed: () {})),
      );
      expect(find.text('Start Round'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        _buildTestApp(
          StartRoundButton(label: 'Go', onPressed: () => pressed = true),
        ),
      );
      await tester.tap(find.text('Go'));
      expect(pressed, true);
    });

    testWidgets('renders as FilledButton', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(StartRoundButton(label: 'Go', onPressed: () {})),
      );
      expect(find.byType(FilledButton), findsOneWidget);
    });
  });
}
