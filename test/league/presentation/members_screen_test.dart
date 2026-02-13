import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/theme.dart';
import 'package:greenie/league/presentation/members_screen.dart';
import 'package:greenie/user/infrastructure/models/member_model.dart';
import 'package:greenie/user/user_providers.dart';

const _testMembers = [
  MemberModel(id: 'member-1', name: 'Alice Smith', handicap: 10),
  MemberModel(id: 'member-2', name: 'Bob Jones', handicap: 18),
];

void main() {
  group('MembersScreen', () {
    testWidgets('shows member list when data loads', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchMembersProvider(
              'league-1',
            ).overrideWith((ref) async => _testMembers),
          ],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: const MembersScreen(leagueId: 'league-1'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Alice Smith'), findsOneWidget);
      expect(find.text('Bob Jones'), findsOneWidget);
      expect(find.textContaining('HC 10'), findsOneWidget);
      expect(find.textContaining('HC 18'), findsOneWidget);
    });

    testWidgets('shows empty state for no members', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchMembersProvider('league-1').overrideWith((ref) async => []),
          ],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: const MembersScreen(leagueId: 'league-1'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('No members yet.'), findsOneWidget);
    });

    testWidgets('shows Members title in app bar', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchMembersProvider(
              'league-1',
            ).overrideWith((ref) async => _testMembers),
          ],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: const MembersScreen(leagueId: 'league-1'),
          ),
        ),
      );
      expect(find.text('Members'), findsOneWidget);
    });
  });
}
