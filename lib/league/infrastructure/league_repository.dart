import 'package:greenie/league/infrastructure/models/league_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'league_repository.g.dart';

@riverpod
LeagueRepository leagueRepository(Ref ref) {
  throw UnimplementedError(
    'leagueRepositoryProvider must be overridden via ProviderScope. '
    'Launch the app via main.dart or main_development.dart.',
  );
}

abstract class LeagueRepository {
  Future<List<LeagueModel>> fetchLeagues();
  Future<LeagueModel> fetchLeague(String id);
}
