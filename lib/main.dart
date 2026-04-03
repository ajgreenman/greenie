// ignore_for_file: scoped_providers_should_specify_dependencies
import 'package:flutter/foundation.dart';
import 'package:greenie/app/core/provider_logger.dart';
import 'package:greenie/bootstrap.dart';
import 'package:greenie/course/infrastructure/infrastructure.dart';
import 'package:greenie/league/infrastructure/infrastructure.dart';
import 'package:greenie/round/infrastructure/infrastructure.dart';
import 'package:greenie/user/infrastructure/infrastructure.dart';

// TODO: Replace fake repositories with Firebase implementations.
void main() => bootstrap(
  observers: kDebugMode ? [const ProviderLogger()] : [],
  overrides: [
    courseRepositoryProvider.overrideWith((_) => FakeCourseRepository()),
    leagueRepositoryProvider.overrideWith((_) => FakeLeagueRepository()),
    roundRepositoryProvider.overrideWith((_) => FakeRoundRepository()),
    userRepositoryProvider.overrideWith((_) => FakeUserRepository()),
  ],
);
