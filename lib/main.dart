import 'package:flutter/foundation.dart';
import 'package:greenie/app/core/provider_logger.dart';
import 'package:greenie/auth/auth_providers.dart';
import 'package:greenie/auth/remote_auth_repository.dart';
import 'package:greenie/bootstrap.dart';
import 'package:greenie/course/infrastructure/infrastructure.dart';
import 'package:greenie/data/supabase/supabase_service.dart';
import 'package:greenie/league/infrastructure/infrastructure.dart';
import 'package:greenie/round/infrastructure/infrastructure.dart';
import 'package:greenie/user/infrastructure/infrastructure.dart';
import 'package:greenie/user/infrastructure/remote_user_repository.dart';

Future<void> main() async {
  await SupabaseService.initialize();

  bootstrap(
    observers: kDebugMode ? [const ProviderLogger()] : [],
    overrides: [
      authRepositoryProvider.overrideWith(
        (ref) => RemoteAuthRepository(ref.watch(supabaseServiceProvider)),
      ),
      // TODO: replace with remote repository implementations.
      courseRepositoryProvider.overrideWith((_) => FakeCourseRepository()),
      leagueRepositoryProvider.overrideWith((_) => FakeLeagueRepository()),
      roundRepositoryProvider.overrideWith((_) => FakeRoundRepository()),
      userRepositoryProvider.overrideWith(
        (ref) => RemoteUserRepository(ref.watch(supabaseServiceProvider)),
      ),
    ],
  );
}
