import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kitshell/panel/logic/battery/battery.dart';
import 'package:kitshell/panel/logic/brightness/brightness.dart';
import 'package:kitshell/panel/logic/sound/sound.dart';
import 'package:kitshell/panel/widgets/submenu/battery_submenu.dart';
import 'package:kitshell/panel/widgets/submenu/wifi_submenu.dart';
import 'package:kitshell/panel/widgets/utility.dart';
import 'package:kitshell/src/rust/api/battery.dart';
import 'package:kitshell/src/rust/api/brightness.dart';
import 'package:kitshell/src/rust/api/wireplumber.dart';

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

class BrightnessPanel extends ConsumerWidget {
  const BrightnessPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = ref.watch(brightnessLogicProvider);

    return HoverRevealer(
      icon: FontAwesomeIcons.sun,
      value: brightness.value?.brightness.first,
      widget: Slider(
        value: brightness.value?.brightness.first.toDouble() ?? 100,
        onChanged: (value) async {
          await setBrightnessAll(brightness: value.toInt());
        },
        max: 100,
      ),
    );
  }
}

class VolumePanel extends HookConsumerWidget {
  const VolumePanel({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soundInfo = ref.watch(soundLogicProvider).value;

    return HoverRevealer(
      icon: FontAwesomeIcons.volumeHigh,
      value: ((soundInfo?.volume ?? 0) * 100).toInt(),
      widget: Slider(
        value: soundInfo?.volume ?? 0,
        onChanged: (value) {
          setVolume(volume: value);
        },
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
      icon: batteryInfo.value!.capacityPercent.first >= 90
          ? FontAwesomeIcons.batteryFull
          : batteryInfo.value!.capacityPercent.first >= 70
              ? FontAwesomeIcons.batteryThreeQuarters
              : batteryInfo.value!.capacityPercent.first >= 40
                  ? FontAwesomeIcons.batteryHalf
                  : batteryInfo.value!.capacityPercent.first >= 15
                      ? FontAwesomeIcons.batteryQuarter
                      : FontAwesomeIcons.batteryEmpty,
      value: batteryInfo.value?.capacityPercent.first.toInt(),
      widget: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            const Gap(4),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  batteryInfo.value?.status.first == BatteryState.full
                      ? 'Full'
                      : batteryInfo.value?.status.first == BatteryState.charging
                          ? 'Charging'
                          : batteryInfo.value?.status.first == BatteryState.discharging
                              ? 'Discharging'
                              : batteryInfo.value?.status.first == BatteryState.empty
                                  ? 'Empty'
                                  : 'Unknown',
                ),
                Text('${batteryInfo.value?.drainRateWatt.first.toStringAsFixed(2)} W'),
              ],
            ),
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
