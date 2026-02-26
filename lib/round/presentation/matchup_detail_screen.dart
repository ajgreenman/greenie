import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenie/app/core/theme/sizes.dart';
import 'package:greenie/round/infrastructure/models/matchup_result.dart';
import 'package:greenie/round/round_providers.dart';
import 'package:greenie/user/infrastructure/models/member_model.dart';

class MatchupDetailScreen extends ConsumerWidget {
  const MatchupDetailScreen({
    super.key,
    required this.leagueId,
    required this.roundId,
    required this.matchupId,
  });

  final String leagueId;
  final String roundId;
  final String matchupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultAsync = ref.watch(
      fetchMatchupResultProvider(roundId, matchupId),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Matchup')),
      body: switch (resultAsync) {
        AsyncData(:final value) => _MatchupDetailBody(result: value),
        AsyncError(:final error) => Center(child: Text('Error: $error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _MatchupDetailBody extends StatelessWidget {
  const _MatchupDetailBody({required this.result});

  final MatchupResult result;

  String _fmt(double pts) {
    if (pts == pts.truncateToDouble()) return pts.toInt().toString();
    return pts.toStringAsFixed(1);
  }

  String _outcomeLabel(MatchupOutcome outcome) => switch (outcome) {
    MatchupOutcome.win => 'Win',
    MatchupOutcome.loss => 'Loss',
    MatchupOutcome.tie => 'Tie',
  };

  Color _outcomeColor(MatchupOutcome outcome, BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return switch (outcome) {
      MatchupOutcome.win => cs.primary,
      MatchupOutcome.loss => cs.error,
      MatchupOutcome.tie => cs.secondary,
    };
  }

  String _initials(MemberModel m) => m.initials;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t1 = result.team1;
    final t2 = result.team2;
    final t1Total = result.team1GrandTotal;
    final t2Total = result.team2GrandTotal;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(GreenieSizes.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: GreenieSizes.large,
        children: [
          // ── Header card ──────────────────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(GreenieSizes.large),
              child: Column(
                spacing: GreenieSizes.small,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          t1.name,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      Text(
                        'vs',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          t2.name,
                          textAlign: TextAlign.end,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _fmt(t1Total),
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      Text(
                        '–',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                      Text(
                        _fmt(t2Total),
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  if (result.holeResults.length == 9)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: GreenieSizes.small,
                      children: [
                        _OutcomeChip(
                          label: _outcomeLabel(result.team1Outcome),
                          color: _outcomeColor(result.team1Outcome, context),
                        ),
                        Text(
                          'Final',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),

          // ── Per-hole table ────────────────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(GreenieSizes.large),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: GreenieSizes.small,
                children: [
                  Text('Hole-by-Hole', style: theme.textTheme.titleSmall),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _HoleTable(result: result, fmt: _fmt),
                  ),
                ],
              ),
            ),
          ),

          // ── Bonus section ─────────────────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(GreenieSizes.large),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: GreenieSizes.small,
                children: [
                  Text('Round Bonus', style: theme.textTheme.titleSmall),
                  _BonusRow(
                    label:
                        '${_initials(result.team1AMember)} vs ${_initials(result.team2AMember)} (A)',
                    t1pts: result.bonusAPoints.team1Points,
                    t2pts: result.bonusAPoints.team2Points,
                    fmt: _fmt,
                  ),
                  const Divider(height: 1),
                  _BonusRow(
                    label:
                        '${_initials(result.team1BMember)} vs ${_initials(result.team2BMember)} (B)',
                    t1pts: result.bonusBPoints.team1Points,
                    t2pts: result.bonusBPoints.team2Points,
                    fmt: _fmt,
                  ),
                  const Divider(height: 1),
                  _BonusRow(
                    label: 'Team combined',
                    t1pts: result.bonusTeamPoints.team1Points,
                    t2pts: result.bonusTeamPoints.team2Points,
                    fmt: _fmt,
                  ),
                ],
              ),
            ),
          ),

          // ── Grand total ───────────────────────────────────────────────────
          Card(
            color: theme.colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(GreenieSizes.large),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          _fmt(t1Total),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(t1.name, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  Text(
                    'Total',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          _fmt(t2Total),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(t2.name, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HoleTable extends StatelessWidget {
  const _HoleTable({required this.result, required this.fmt});

  final MatchupResult result;
  final String Function(double) fmt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t1A = result.team1AMember.initials;
    final t2A = result.team2AMember.initials;
    final t1B = result.team1BMember.initials;
    final t2B = result.team2BMember.initials;

    final headers = [
      'Hole',
      '$t1A Net',
      '$t2A Net',
      'A Pts',
      '$t1B Net',
      '$t2B Net',
      'B Pts',
      'T1 Net',
      'T2 Net',
      'Team Pts',
    ];

    // Build hole rows — include all hole numbers, show "—" if not yet played.
    final holeNumbers = result.holeNumbers;
    final playedMap = {for (final h in result.holeResults) h.holeNumber: h};

    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      border: TableBorder.all(
        color: theme.colorScheme.outlineVariant,
        width: 0.5,
      ),
      children: [
        // Header row
        TableRow(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
          ),
          children: headers
              .map((h) => _cell(h, theme, isHeader: true))
              .toList(),
        ),
        // Data rows
        ...holeNumbers.map((hole) {
          final h = playedMap[hole];
          return TableRow(
            children: h != null
                ? [
                    _cell('$hole', theme),
                    _cell('${h.team1ANet}', theme),
                    _cell('${h.team2ANet}', theme),
                    _cell(
                      '${fmt(h.aPoints.team1Points)}–${fmt(h.aPoints.team2Points)}',
                      theme,
                    ),
                    _cell('${h.team1BNet}', theme),
                    _cell('${h.team2BNet}', theme),
                    _cell(
                      '${fmt(h.bPoints.team1Points)}–${fmt(h.bPoints.team2Points)}',
                      theme,
                    ),
                    _cell('${h.team1TeamNet}', theme),
                    _cell('${h.team2TeamNet}', theme),
                    _cell(
                      '${fmt(h.teamPoints.team1Points)}–${fmt(h.teamPoints.team2Points)}',
                      theme,
                    ),
                  ]
                : List.generate(10, (_) => _cell('—', theme)),
          );
        }),
      ],
    );
  }

  Widget _cell(String text, ThemeData theme, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: GreenieSizes.small,
        vertical: GreenieSizes.extraSmall,
      ),
      child: Text(
        text,
        style: isHeader
            ? theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold)
            : theme.textTheme.bodySmall,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _BonusRow extends StatelessWidget {
  const _BonusRow({
    required this.label,
    required this.t1pts,
    required this.t2pts,
    required this.fmt,
  });

  final String label;
  final double t1pts;
  final double t2pts;
  final String Function(double) fmt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: GreenieSizes.extraSmall),
      child: Row(
        children: [
          Expanded(child: Text(label, style: theme.textTheme.bodySmall)),
          Text(
            '${fmt(t1pts)} – ${fmt(t2pts)}',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _OutcomeChip extends StatelessWidget {
  const _OutcomeChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: GreenieSizes.small,
        vertical: GreenieSizes.extraSmall,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
