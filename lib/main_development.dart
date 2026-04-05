import 'package:greenie/app/core/provider_logger.dart';
import 'package:greenie/auth/auth_providers.dart';
import 'package:greenie/auth/fake_auth_repository.dart';
import 'package:greenie/bootstrap.dart';
import 'package:greenie/course/infrastructure/infrastructure.dart';
import 'package:greenie/league/infrastructure/infrastructure.dart';
import 'package:greenie/round/infrastructure/infrastructure.dart';
import 'package:greenie/user/infrastructure/infrastructure.dart';

void main() {
  bootstrap(
    observers: [const ProviderLogger()],
    overrides: [
      authRepositoryProvider.overrideWith((_) => FakeAuthRepository()),
      courseRepositoryProvider.overrideWith((_) => FakeCourseRepository()),
      leagueRepositoryProvider.overrideWith((_) => FakeLeagueRepository()),
      roundRepositoryProvider.overrideWith((_) => FakeRoundRepository()),
      userRepositoryProvider.overrideWith((ref) => FakeUserRepository(
        authRepository: ref.watch(authRepositoryProvider),
      )),
    ],
  );
}
