import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenie/app/core/provider_logger.dart';
import 'package:greenie/auth/auth_providers.dart';
import 'package:greenie/auth/fake_auth_repository.dart';
import 'package:greenie/course/infrastructure/infrastructure.dart';
import 'package:greenie/dev/dev_app.dart';
import 'package:greenie/dev/dev_scenario_notifier.dart';
import 'package:greenie/league/infrastructure/infrastructure.dart';
import 'package:greenie/round/infrastructure/infrastructure.dart';
import 'package:greenie/user/infrastructure/infrastructure.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      observers: [const ProviderLogger()],
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
      child: const DevApp(),
    ),
  );
}
