import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/theme/theme.dart';
import 'package:greenie/league/presentation/components/stat_card.dart';

void main() {
  group('StatCard', () {
    testWidgets('renders label and value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: GreenieTheme.light,
          home: const Scaffold(
            body: StatCard(label: 'Rounds Played', value: '5'),
          ),
        ),
      );
      expect(find.text('Rounds Played'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('renders dash value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: GreenieTheme.light,
          home: const Scaffold(
            body: StatCard(label: 'Best Round', value: '-'),
          ),
        ),
      );
      expect(find.text('Best Round'), findsOneWidget);
      expect(find.text('-'), findsOneWidget);
    });
  });
}
