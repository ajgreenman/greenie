import 'package:greenie/league/infrastructure/fake_league_repository.dart';
import 'package:greenie/league/infrastructure/models/league_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'league_repository.g.dart';

@riverpod
LeagueRepository leagueRepository(Ref ref) {
  return FakeLeagueRepository();
}

abstract class LeagueRepository {
  Future<List<LeagueModel>> fetchLeagues();
  Future<LeagueModel?> fetchLeague(String id);
}
