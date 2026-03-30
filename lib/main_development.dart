import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenie/bootstrap.dart';
import 'package:greenie/course/infrastructure/course_repository.dart';
import 'package:greenie/course/infrastructure/fake_course_repository.dart';
import 'package:greenie/league/infrastructure/fake_league_repository.dart';
import 'package:greenie/league/infrastructure/league_repository.dart';
import 'package:greenie/round/infrastructure/fake_round_repository.dart';
import 'package:greenie/round/infrastructure/round_repository.dart';
import 'package:greenie/user/infrastructure/fake_user_repository.dart';
import 'package:greenie/user/infrastructure/user_repository.dart';

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
