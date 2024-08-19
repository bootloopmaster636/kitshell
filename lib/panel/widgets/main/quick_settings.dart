import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kitshell/panel/logic/battery/battery.dart';
import 'package:kitshell/panel/logic/sound/sound.dart';
import 'package:kitshell/panel/widgets/submenu/battery_submenu.dart';
import 'package:kitshell/panel/widgets/submenu/wifi_submenu.dart';
import 'package:kitshell/panel/widgets/utility.dart';
import 'package:kitshell/src/rust/api/brightness.dart';

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

class BrightnessPanel extends StatefulWidget {
  const BrightnessPanel({
    super.key,
  });

  @override
  State<BrightnessPanel> createState() => _BrightnessPanelState();
}

class _BrightnessPanelState extends State<BrightnessPanel> {
  late Stream<BrightnessData> brightnessStream;

  @override
  void initState() {
    super.initState();
    brightnessStream = getBrightnessStream();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: brightnessStream,
      builder: (context, snap) {
        return HoverRevealer(
          icon: FontAwesomeIcons.sun,
          value: snap.data?.brightness.first,
          widget: Slider(
            value: snap.data?.brightness.first.toDouble() ?? 100,
            onChanged: (value) async {
              await setBrightnessAll(brightness: value.toInt());
            },
            max: 100,
            activeColor: Theme.of(context).colorScheme.onSurface,
            inactiveColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
        );
      },
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
          ref.read(soundLogicProvider.notifier).setVolume(value);
        },
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
      icon: batteryInfo.value?.icon ?? FontAwesomeIcons.batteryEmpty,
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
