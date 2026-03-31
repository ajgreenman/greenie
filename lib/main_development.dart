import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenie/bootstrap.dart';
import 'package:greenie/course/infrastructure/infrastructure.dart';
import 'package:greenie/league/infrastructure/infrastructure.dart';
import 'package:greenie/round/infrastructure/infrastructure.dart';
import 'package:greenie/user/infrastructure/infrastructure.dart';

void main() => bootstrap(
  ProviderScope(
    overrides: [
      courseRepositoryProvider.overrideWith((_) => FakeCourseRepository()),
      leagueRepositoryProvider.overrideWith((_) => FakeLeagueRepository()),
      roundRepositoryProvider.overrideWith((_) => FakeRoundRepository()),
      userRepositoryProvider.overrideWith((_) => FakeUserRepository()),
    ],
    child: const App(),
  ),
);
