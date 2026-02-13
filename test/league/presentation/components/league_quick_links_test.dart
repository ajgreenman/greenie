import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/theme.dart';
import 'package:greenie/league/presentation/components/league_quick_links.dart';

Widget _buildTestApp(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      theme: buildLightTheme(),
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  group('LeagueQuickLinks', () {
    testWidgets('shows Members, Past Rounds, Standings', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          const LeagueQuickLinks(leagueId: 'league-1', isAdmin: false),
        ),
      );
      expect(find.text('Members'), findsOneWidget);
      expect(find.text('Past Rounds'), findsOneWidget);
      expect(find.text('Standings'), findsOneWidget);
    });

    testWidgets('shows Admin tile when isAdmin is true', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          const LeagueQuickLinks(leagueId: 'league-1', isAdmin: true),
        ),
      );
      expect(find.text('Admin'), findsOneWidget);
      expect(find.byIcon(Icons.admin_panel_settings), findsOneWidget);
    });

    testWidgets('hides Admin tile when isAdmin is false', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          const LeagueQuickLinks(leagueId: 'league-1', isAdmin: false),
        ),
      );
      expect(find.text('Admin'), findsNothing);
    });
  });
}
