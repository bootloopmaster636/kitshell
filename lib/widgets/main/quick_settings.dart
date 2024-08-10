import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:kitshell/logic/battery/battery.dart';
import 'package:kitshell/widgets/submenu/battery_submenu.dart';
import 'package:kitshell/widgets/utility.dart';

import '../submenu/wifi_submenu.dart';

class QuickSettingsContainer extends StatelessWidget {
  const QuickSettingsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        BatteryPanel(),
        Gap(8),
        VolumePanel(),
        Gap(8),
        BrightnessPanel(),
        Gap(8),
        WifiPanel(),
      ],
    );
  }
}

class WifiPanel extends StatelessWidget {
  const WifiPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return HoverRevealer(
      icon: FontAwesomeIcons.wifi,
      widget: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SSID'),
                  Text('Connected'),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WifiSubmenu(),
                  ),
                );
              },
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
      ),
    );
  }
}

class BrightnessPanel extends StatelessWidget {
  const BrightnessPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return HoverRevealer(
      icon: FontAwesomeIcons.sun,
      value: 56,
      widget: Slider(
        value: 0.5,
        onChanged: (value) {},
        activeColor: Theme.of(context).colorScheme.onSurface,
        inactiveColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
      ),
    );
  }
}

class VolumePanel extends StatelessWidget {
  const VolumePanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return HoverRevealer(
      icon: FontAwesomeIcons.volumeHigh,
      value: 56,
      widget: Slider(
        value: 0.5,
        onChanged: (value) {},
        activeColor: Theme.of(context).colorScheme.onSurface,
        inactiveColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
      ),
    );
  }
}

class BatteryPanel extends ConsumerWidget {
  const BatteryPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final batteryInfo = ref.watch(batteryLogicProvider);
    return HoverRevealer(
      icon: FontAwesomeIcons.batteryThreeQuarters,
      value: batteryInfo.value?.level,
      widget: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Text(batteryInfo.value?.state.toString().split('.').last ?? 'Status not available'),
            const Spacer(),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BatterySubmenu(),
                  ),
                );
              },
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
      ),
    );
  }
}
