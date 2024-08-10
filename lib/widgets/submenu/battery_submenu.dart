import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:kitshell/const.dart';
import 'package:kitshell/logic/battery/battery.dart';
import 'package:kitshell/widgets/utility.dart';

class BatterySubmenu extends StatelessWidget {
  const BatterySubmenu({super.key});

  @override
  Widget build(BuildContext context) {
    return const Submenu(
      icon: FontAwesomeIcons.batteryThreeQuarters,
      title: 'Battery',
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: panelHeight / 4),
        child: PowerProfilesSettings(),
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
            selected: selectedProfile.value?.profile == PowerProfiles.powersave,
            onSelected: (selected) {
              ref.read(powerProfilesLogicProvider.notifier).changePowerProfiles(PowerProfiles.powersave);
            },
          ),
          const Gap(4),
          ChoiceChip(
            label: const Text('Balanced'),
            selected: selectedProfile.value?.profile == PowerProfiles.balanced,
            onSelected: (selected) {
              ref.read(powerProfilesLogicProvider.notifier).changePowerProfiles(PowerProfiles.balanced);
            },
          ),
          const Gap(4),
          ChoiceChip(
            label: const Text('Performance'),
            selected: selectedProfile.value?.profile == PowerProfiles.performance,
            onSelected: (selected) {
              ref.read(powerProfilesLogicProvider.notifier).changePowerProfiles(PowerProfiles.performance);
            },
          ),
        ],
      ),
    );
  }
}
