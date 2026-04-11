import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenie/dev/dev_scenario.dart';
import 'package:greenie/dev/dev_scenario_notifier.dart';

/// Injects a scenario-switcher FAB into the widget tree.
/// Wire up via MaterialApp's [builder] parameter in dev builds only.
class DevMenuOverlay extends ConsumerWidget {
  const DevMenuOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(devScenarioProvider);
    return Positioned(
      right: 16,
      bottom: 96,
      child: FloatingActionButton.small(
        heroTag: 'devMenu',
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        tooltip: 'Dev scenario: ${current.displayName}',
        onPressed: () => _showPicker(context, ref, current),
        child: const Icon(Icons.developer_mode),
      ),
    );
  }

  void _showPicker(BuildContext context, WidgetRef ref, DevScenario current) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _ScenarioPicker(
        current: current,
        onSelect: (scenario) {
          ref.read(devScenarioProvider.notifier).select(scenario);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

class _ScenarioPicker extends StatelessWidget {
  const _ScenarioPicker({
    required this.current,
    required this.onSelect,
  });

  final DevScenario current;
  final void Function(DevScenario) onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              children: [
                const Icon(Icons.developer_mode, color: Colors.deepOrange),
                const SizedBox(width: 8),
                Text(
                  'Dev Scenario',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          ...allDevScenarios.map(
            (scenario) => _ScenarioTile(
              scenario: scenario,
              isSelected: scenario.runtimeType == current.runtimeType,
              onTap: () => onSelect(scenario),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _ScenarioTile extends StatelessWidget {
  const _ScenarioTile({
    required this.scenario,
    required this.isSelected,
    required this.onTap,
  });

  final DevScenario scenario;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: isSelected
          ? Icon(Icons.radio_button_checked, color: theme.colorScheme.primary)
          : const Icon(Icons.radio_button_unchecked),
      title: Text(
        scenario.displayName,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(scenario.description),
      onTap: onTap,
    );
  }
}
