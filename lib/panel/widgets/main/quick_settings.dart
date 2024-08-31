import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kitshell/panel/logic/battery/battery.dart';
import 'package:kitshell/panel/logic/brightness/brightness.dart';
import 'package:kitshell/panel/logic/sound/sound.dart';
import 'package:kitshell/panel/logic/wifi/wifi.dart';
import 'package:kitshell/panel/widgets/submenu/battery_submenu.dart';
import 'package:kitshell/panel/widgets/submenu/wifi_submenu.dart';
import 'package:kitshell/panel/widgets/utility_widgets.dart';
import 'package:kitshell/src/rust/api/battery.dart';
import 'package:kitshell/src/rust/api/brightness.dart';
import 'package:kitshell/src/rust/api/wireplumber.dart';
import 'package:page_transition/page_transition.dart';

class QuickSettingsContainer extends StatelessWidget {
  const QuickSettingsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return const RepaintBoundary(
      child: Row(
        children: [
          Gap(4),
          BatteryPanel(),
          Gap(8),
          VolumePanel(),
          Gap(8),
          BrightnessPanel(),
          Gap(8),
          WifiPanel(),
        ],
      ),
    );
  }
}

class WifiPanel extends ConsumerWidget {
  const WifiPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wifi = ref.watch(wifiListProvider);

    return HoverRevealer(
      icon: FontAwesomeIcons.wifi,
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.bottomToTop,
            duration: const Duration(milliseconds: 100),
            reverseDuration: const Duration(milliseconds: 120),
            curve: Curves.easeOutExpo,
            child: const WifiSubmenu(),
          ),
        );
      },
      widget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Text(
              '${wifi.value?.where((element) => element.isConnected == true).first.ssid ?? 'Unknown'}'
              ' (${wifi.value?.where((element) => element.isConnected == true).first.signalStrength ?? 0}%)',
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
      icon: (batteryInfo.value?.capacityPercent.first ?? 100) >= 90
          ? FontAwesomeIcons.batteryFull
          : batteryInfo.value!.capacityPercent.first >= 70
              ? FontAwesomeIcons.batteryThreeQuarters
              : batteryInfo.value!.capacityPercent.first >= 40
                  ? FontAwesomeIcons.batteryHalf
                  : batteryInfo.value!.capacityPercent.first >= 15
                      ? FontAwesomeIcons.batteryQuarter
                      : FontAwesomeIcons.batteryEmpty,
      value: batteryInfo.value?.capacityPercent.first.toInt(),
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.bottomToTop,
            duration: const Duration(milliseconds: 100),
            reverseDuration: const Duration(milliseconds: 120),
            curve: Curves.easeOutExpo,
            child: const BatterySubmenu(),
          ),
        );
      },
      widget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            const Gap(4),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(4),
              child: Text(
                batteryInfo.value?.status.isEmpty ?? false
                    ? 'Loading'
                    : batteryInfo.value?.status.first == BatteryState.full
                        ? 'Full'
                        : batteryInfo.value?.status.first == BatteryState.charging
                            ? 'Charging'
                            : batteryInfo.value?.status.first == BatteryState.discharging
                                ? '${batteryInfo.value?.capacityPercent.first.toInt()}%'
                                : batteryInfo.value?.status.first == BatteryState.empty
                                    ? 'Empty'
                                    : 'Unknown',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            const Gap(8),
            Text('${batteryInfo.value?.drainRateWatt.first.toStringAsFixed(2)} W'),
          ],
        ),
      ),
    );
  }
}
