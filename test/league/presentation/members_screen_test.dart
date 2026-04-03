import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/theme/theme.dart';
import 'package:greenie/league/presentation/members_screen.dart';
import 'package:greenie/user/infrastructure/models/member_model.dart';
import 'package:greenie/user/user_providers.dart';

// Alphabetical: Alice, Bob, Carol
// By handicap:  Bob (5), Alice (10), Carol (18)
const _testMembers = [
  MemberModel(id: 'member-1', name: 'Alice', handicap: 10),
  MemberModel(id: 'member-2', name: 'Bob', handicap: 5),
  MemberModel(id: 'member-3', name: 'Carol', handicap: 18),
];

Widget _buildScreen({List<MemberModel> members = _testMembers}) {
  return ProviderScope(
    overrides: [
      fetchMembersProvider(
        'league-1',
      ).overrideWith((ref) async => members),
    ],
    child: MaterialApp(
      theme: GreenieTheme.light,
      home: const MembersScreen(leagueId: 'league-1'),
    ),
  );
}

void main() {
  group('MembersScreen', () {
    testWidgets('shows Members title in app bar', (tester) async {
      await tester.pumpWidget(_buildScreen());
      expect(find.text('Members'), findsOneWidget);
    });

    testWidgets('shows member list when data loads', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('shows empty state for no members', (tester) async {
      await tester.pumpWidget(_buildScreen(members: []));
      await tester.pumpAndSettle();
      expect(find.text('No members yet'), findsOneWidget);
    });

    testWidgets('shows Name and Handicap sort toggle', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Handicap'), findsOneWidget);
    });

    testWidgets('default order is alphabetical', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();
      final alice = tester.getTopLeft(find.text('Alice'));
      final bob = tester.getTopLeft(find.text('Bob'));
      final carol = tester.getTopLeft(find.text('Carol'));
      expect(alice.dy, lessThan(bob.dy));
      expect(bob.dy, lessThan(carol.dy));
    });

    testWidgets('toggling to Handicap sorts by handicap ascending',
        (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Handicap'));
      await tester.pump();
      // Bob (5) < Alice (10) < Carol (18)
      final bob = tester.getTopLeft(find.text('Bob'));
      final alice = tester.getTopLeft(find.text('Alice'));
      final carol = tester.getTopLeft(find.text('Carol'));
      expect(bob.dy, lessThan(alice.dy));
      expect(alice.dy, lessThan(carol.dy));
    });

    testWidgets('toggling back to Name restores alphabetical order',
        (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Handicap'));
      await tester.pump();
      await tester.tap(find.text('Name'));
      await tester.pump();
      final alice = tester.getTopLeft(find.text('Alice'));
      final bob = tester.getTopLeft(find.text('Bob'));
      expect(alice.dy, lessThan(bob.dy));
    });
  });
}
