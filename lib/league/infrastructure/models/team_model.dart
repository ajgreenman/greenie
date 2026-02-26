class TeamModel {
  const TeamModel({
    required this.id,
    required this.leagueId,
    required this.memberIds,
    required this.name,
  });

  final String id;
  final String leagueId;

  /// Exactly 2 member IDs — index 0 and 1.
  final List<String> memberIds;

  final String name;
}
