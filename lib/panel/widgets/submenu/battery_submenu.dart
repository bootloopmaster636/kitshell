import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:kitshell/panel/logic/battery/battery.dart';
import 'package:kitshell/panel/widgets/utility_widgets.dart';
import 'package:kitshell/settings/logic/layer_shell/layer_shell.dart';
import 'package:kitshell/src/rust/api/battery.dart';

class BatterySubmenu extends ConsumerWidget {
  const BatterySubmenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final panelHeight = ref.watch(layerShellLogicProvider).value!.panelHeight;

    return Submenu(
      icon: FontAwesomeIcons.batteryThreeQuarters,
      title: 'Battery',
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: panelHeight / 4),
        child: const PowerProfilesSettings(),
      ),
    );
  }
}

class PowerProfilesSettings extends ConsumerWidget {
  const PowerProfilesSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProfile = ref.watch(powerProfilesLogicProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const Text('Power Profile:'),
          const Gap(8),
          ChoiceChip(
            label: const Text('Power Saver'),
            selected: selectedProfile.value == PowerProfiles.powersave,
            onSelected: (selected) {
              ref.read(powerProfilesLogicProvider.notifier).changePowerProfiles(PowerProfiles.powersave);
            },
          ),
          const Gap(4),
          ChoiceChip(
            label: const Text('Balanced'),
            selected: selectedProfile.value == PowerProfiles.balanced,
            onSelected: (selected) {
              ref.read(powerProfilesLogicProvider.notifier).changePowerProfiles(PowerProfiles.balanced);
            },
          ),
          const Gap(4),
          ChoiceChip(
            label: const Text('Performance'),
            selected: selectedProfile.value == PowerProfiles.performance,
            onSelected: (selected) {
              ref.read(powerProfilesLogicProvider.notifier).changePowerProfiles(PowerProfiles.performance);
            },
          ),
        ],
      ),
    );
  }
}
