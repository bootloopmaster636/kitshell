import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
      icon: Icons.wifi,
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
      icon: Icons.brightness_medium_outlined,
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
      icon: Icons.volume_up_outlined,
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

class BatteryPanel extends StatelessWidget {
  const BatteryPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return HoverRevealer(
      icon: Icons.battery_0_bar_rounded,
      value: 56,
      widget: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('75%'),
                  Text('0.5W'),
                ],
              ),
            ),
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
