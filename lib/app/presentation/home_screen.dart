import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenie/app/core/theme/sizes.dart';
import 'package:greenie/app/presentation/components/components.dart';
import 'package:greenie/league/league_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leagues = ref.watch(fetchLeaguesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Greenie')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              GreenieSizes.large,
              GreenieSizes.large,
              GreenieSizes.large,
              GreenieSizes.small,
            ),
            child: Text(
              'My Leagues',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: switch (leagues) {
              AsyncData(:final value) when value.isEmpty => const EmptyState(
                icon: Icons.flag_outlined,
                message: 'No leagues yet.',
              ),
              AsyncData(:final value) => ListView.separated(
                itemCount: value.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final league = value[index];
                  return ListTile(
                    leading: const Icon(Icons.flag),
                    title: Text(league.name),
                    subtitle: Row(
                      children: [
                        Text(league.course.name),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: GreenieSizes.extraSmall,
                          ),
                          child: Icon(
                            Icons.circle,
                            size: GreenieSizes.extraSmall,
                          ),
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
          ),
        ],
      ),
    );
  }
}
