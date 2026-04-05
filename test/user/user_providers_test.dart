import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/user/infrastructure/infrastructure.dart';
import 'package:greenie/user/user_providers.dart';

void main() {
  ProviderContainer makeContainer() => ProviderContainer(
    overrides: [
      userRepositoryProvider.overrideWithValue(FakeUserRepository()),
    ],
  );

  group('User Providers', () {
    test('currentUserProvider returns a user', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      final user = await container.read(currentUserProvider.future);
      expect(user.name, isNotEmpty);
    });

    test('fetchMembersProvider returns members for league', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      final members = await container.read(
        fetchMembersProvider('league-1').future,
      );
      expect(members, isNotEmpty);
    });
  });
}
