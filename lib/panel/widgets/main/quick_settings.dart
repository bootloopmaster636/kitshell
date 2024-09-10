import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
import 'package:kitshell/settings/logic/layer_shell/layer_shell.dart';
import 'package:kitshell/src/rust/api/battery.dart';
import 'package:kitshell/src/rust/api/brightness.dart';
import 'package:kitshell/src/rust/api/wireplumber.dart';
import 'package:page_transition/page_transition.dart';

class QuickSettingsContainer extends StatelessWidget {
  const QuickSettingsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SliderTheme(
        data: SliderThemeData(
          trackHeight: 24,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 13),
          overlayShape: SliderComponentShape.noOverlay,
        ),
        child: Row(
          children: [
            const BatteryPanel(),
            const VolumePanel(),
            const BrightnessPanel(),
            const WifiPanel(),
          ]
              .map((e) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: e,
                  ))
              .toList()
              .animate(interval: 100.ms, delay: 600.ms)
              .slideY(
                begin: 1,
                end: 0,
                duration: 800.ms,
                curve: Curves.easeOutExpo,
              ),
        ),
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
    final panelHeight = ref.watch(layerShellLogicProvider).value!.panelHeight;

    return HoverRevealer(
      icon: (wifi.value?.where((e) => e.isConnected).first.signalStrength ?? 0) > 75
          ? Icons.wifi
          : (wifi.value?.where((e) => e.isConnected).first.signalStrength ?? 0) > 50
              ? Icons.wifi_2_bar_outlined
              : Icons.wifi_1_bar_rounded,
      iconSize: panelHeight / 2.5,
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
      widget: Padding(
        padding: const EdgeInsets.only(left: 4, right: 12),
        child: Row(
          children: [
            Flexible(
              flex: 6,
              child: Slider(
                value: brightness.value?.brightness.first.toDouble() ?? 100,
                onChanged: (value) async {
                  await setBrightnessAll(brightness: value.toInt());
                  await ref.read(brightnessLogicProvider.notifier).updateValue();
                },
                max: 100,
              ),
            ),
            Flexible(
              child: Text(
                '${brightness.value?.brightness.first}',
              ),
            ),
          ],
        ),
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
      icon: (soundInfo?.volume ?? 0) > 0.6
          ? FontAwesomeIcons.volumeHigh
          : (soundInfo?.volume ?? 0) > 0.3
              ? FontAwesomeIcons.volumeLow
              : FontAwesomeIcons.volumeOff,
      value: ((soundInfo?.volume ?? 0) * 100).toInt(),
      widget: Padding(
        padding: const EdgeInsets.only(left: 4, right: 12),
        child: Row(
          children: [
            Flexible(
              flex: 6,
              child: Slider(
                value: soundInfo?.volume ?? 0,
                onChanged: (value) async {
                  await setVolume(volume: value);
                  await ref.read(soundLogicProvider.notifier).updateValue();
                },
              ),
            ),
            Flexible(
              child: Text(
                ((soundInfo?.volume ?? 0) * 100).toStringAsFixed(0),
              ),
            ),
          ],
        ),
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
      iconOverlay: batteryInfo.value != null && batteryInfo.value!.status.isNotEmpty
          ? (batteryInfo.value?.status.first == BatteryState.charging ? FontAwesomeIcons.bolt : null)
          : null,
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
