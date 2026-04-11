import 'package:greenie/app/core/provider_logger.dart';
import 'package:greenie/auth/auth_providers.dart';
import 'package:greenie/auth/fake_auth_repository.dart';
import 'package:greenie/bootstrap.dart';
import 'package:greenie/course/infrastructure/infrastructure.dart';
import 'package:greenie/dev/dev_menu.dart';
import 'package:greenie/dev/dev_scenario_notifier.dart';
import 'package:greenie/league/infrastructure/infrastructure.dart';
import 'package:greenie/round/infrastructure/infrastructure.dart';
import 'package:greenie/user/infrastructure/infrastructure.dart';

void main() {
  bootstrap(
    observers: [const ProviderLogger()],
    devOverlay: const DevMenuOverlay(),
    overrides: [
      authRepositoryProvider.overrideWith((_) => FakeAuthRepository()),
      courseRepositoryProvider.overrideWith((_) => FakeCourseRepository()),
      leagueRepositoryProvider.overrideWith((ref) {
        final scenario = ref.watch(devScenarioProvider);
        return FakeLeagueRepository(scenario: scenario);
      }),
      roundRepositoryProvider.overrideWith((ref) {
        final scenario = ref.watch(devScenarioProvider);
        return FakeRoundRepository(scenario: scenario);
      }),
      userRepositoryProvider.overrideWith((ref) {
        final scenario = ref.watch(devScenarioProvider);
        return FakeUserRepository(scenario: scenario);
      }),
    ],
  );
}
