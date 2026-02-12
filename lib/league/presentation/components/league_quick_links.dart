import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LeagueQuickLinks extends StatelessWidget {
  const LeagueQuickLinks({
    super.key,
    required this.leagueId,
    required this.isAdmin,
  });

  final String leagueId;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _QuickLinkTile(
            icon: Icons.people,
            label: 'Members',
            onTap: () => context.go('/league/$leagueId/members'),
          ),
          _QuickLinkTile(
            icon: Icons.history,
            label: 'Past Rounds',
            onTap: () => context.go('/league/$leagueId/rounds'),
          ),
          _QuickLinkTile(
            icon: Icons.leaderboard,
            label: 'Standings',
            onTap: () {},
          ),
          if (isAdmin)
            _QuickLinkTile(
              icon: Icons.admin_panel_settings,
              label: 'Admin',
              onTap: () {},
            ),
        ],
      ),
    );
  }
}

class _QuickLinkTile extends StatelessWidget {
  const _QuickLinkTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 100,
      height: 90,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(height: 4),
              Text(label, style: theme.textTheme.labelSmall),
            ],
          ),
        ),
      ),
    );
  }
}
