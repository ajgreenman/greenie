import 'package:flutter/material.dart';
import 'package:greenie/app/core/theme/sizes.dart';
import 'package:greenie/league/infrastructure/models/models.dart';

class LeagueInfoHeader extends StatelessWidget {
  const LeagueInfoHeader({super.key, required this.league});

  final LeagueModel league;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: GreenieSizes.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: GreenieSizes.small,
        children: [
          Text(
            league.course.name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            spacing: GreenieSizes.extraSmall,
            children: [
              Icon(
                Icons.calendar_today,
                size: GreenieSizes.large,
                color: theme.colorScheme.outline,
              ),
              Text(
                '${league.day.displayName}s',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
