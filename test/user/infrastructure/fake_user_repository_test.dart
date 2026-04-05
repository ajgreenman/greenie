import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/user/infrastructure/fake_user_repository.dart';

void main() {
  late FakeUserRepository repo;

  setUp(() {
    repo = FakeUserRepository();
  });

  group('FakeUserRepository', () {
    test('getCurrentUser returns a user with name and email', () async {
      final user = await repo.getCurrentUser();
      expect(user.name, isNotEmpty);
      expect(user.email, isNotEmpty);
    });

    test('getCurrentUser defaults to AJ Greenman (member-1)', () async {
      final user = await repo.getCurrentUser();
      expect(user.memberId, 'member-1');
    });

    test('fetchMembersForLeague returns members', () async {
      final members = await repo.fetchMembersForLeague('league-1');
      expect(members.length, 14);
    });

    test('members have unique IDs', () async {
      final members = await repo.fetchMembersForLeague('league-1');
      final ids = members.map((m) => m.id).toSet();
      expect(ids.length, members.length);
    });

    test('members have valid handicaps', () async {
      final members = await repo.fetchMembersForLeague('league-1');
      for (final member in members) {
        expect(member.handicap, greaterThanOrEqualTo(0));
      }
    });
  });
}
