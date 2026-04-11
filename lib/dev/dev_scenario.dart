sealed class DevScenario {
  const DevScenario();

  /// Short label shown in the scenario picker.
  String get displayName;

  /// One-line description shown below the label.
  String get description;
}

/// Brand new user — no leagues, nothing to see yet.
/// Tests: first-run experience, onboarding CTA.
final class FreshSignup extends DevScenario {
  const FreshSignup();
  @override
  String get displayName => 'Fresh Signup';
  @override
  String get description => 'New user with no leagues';
}

/// Admin just created a league. Only they are a member, no rounds scheduled.
/// Tests: empty home screen, admin setup prompts.
final class NewLeagueAdmin extends DevScenario {
  const NewLeagueAdmin();
  @override
  String get displayName => 'New League — Admin';
  @override
  String get description => 'Admin view of a freshly created league';
}

/// Regular member who just accepted an invite. League exists but is empty.
/// Tests: member view of empty league, no admin controls visible.
final class NewLeagueMember extends DevScenario {
  const NewLeagueMember();
  @override
  String get displayName => 'New League — Member';
  @override
  String get description => 'Just joined, league has no rounds yet';
}

/// League is set up with teams, first round is scheduled but not started.
/// Tests: upcoming round hero card, pre-round anticipation feel.
final class FirstRoundUpcoming extends DevScenario {
  const FirstRoundUpcoming();
  @override
  String get displayName => 'First Round Upcoming';
  @override
  String get description => 'Teams formed, first round on the schedule';
}

/// A round is actively being played right now with partial scores.
/// Tests: round-in-progress urgency, score entry flow.
final class RoundInProgress extends DevScenario {
  const RoundInProgress();
  @override
  String get displayName => 'Round In Progress';
  @override
  String get description => 'Active round, partial scores entered';
}

/// Mid-season — several rounds done, standings populated, one round upcoming.
/// This is the default and most feature-rich view.
final class ActiveSeason extends DevScenario {
  const ActiveSeason();
  @override
  String get displayName => 'Active Season';
  @override
  String get description => 'Default: standings, history, upcoming round';
}

/// All rounds finished. No upcoming card, final standings locked in.
/// Tests: end-of-season feel, what do members do now?
final class SeasonComplete extends DevScenario {
  const SeasonComplete();
  @override
  String get displayName => 'Season Complete';
  @override
  String get description => 'All rounds done, final standings';
}

/// User is a member of two leagues simultaneously.
/// Tests: league list, switching between leagues.
final class MultiLeague extends DevScenario {
  const MultiLeague();
  @override
  String get displayName => 'Multi-League';
  @override
  String get description => 'Member of two leagues at once';
}

/// All available scenarios in display order.
const allDevScenarios = <DevScenario>[
  FreshSignup(),
  NewLeagueAdmin(),
  NewLeagueMember(),
  FirstRoundUpcoming(),
  RoundInProgress(),
  ActiveSeason(),
  SeasonComplete(),
  MultiLeague(),
];
