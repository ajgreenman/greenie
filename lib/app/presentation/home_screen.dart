import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenie/app/presentation/components/empty_state.dart';
import 'package:greenie/league/league_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leagues = ref.watch(fetchLeaguesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Greenie')),
      body: switch (leagues) {
        AsyncData(:final value) when value.isEmpty => const EmptyState(
          icon: Icons.sports_golf,
          message: 'No leagues yet.',
        ),
        AsyncData(:final value) => ListView.builder(
          itemCount: value.length,
          itemBuilder: (context, index) {
            final league = value[index];
            return ListTile(
              leading: const Icon(Icons.emoji_events),
              title: Text(league.name),
              subtitle: Row(
                children: [
                  Text(league.course.name),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(Icons.circle, size: 4),
                  ),
                  Text('${league.day.displayName}s'),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/league/${league.id}'),
            );
          },
        ),
        AsyncError(:final error) => Center(child: Text('Error: $error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
