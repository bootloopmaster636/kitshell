import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kitshell/const.dart';
import 'package:kitshell/panel/logic/utility_function.dart';
import 'package:kitshell/panel/logic/wifi/wifi.dart';
import 'package:kitshell/panel/widgets/utility_widgets.dart';
import 'package:kitshell/settings/logic/layer_shell/layer_shell.dart';
import 'package:kitshell/src/rust/api/wifi.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

class WifiSubmenu extends ConsumerWidget {
  const WifiSubmenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wifiList = ref.watch(wifiListProvider);

    return Submenu(
      icon: FontAwesomeIcons.wifi,
      title: 'Wi-Fi',
      action: IconButton(
        onPressed: () {
          ref.read(wifiListProvider.notifier).scanWifi();
        },
        icon: const Icon(Icons.refresh_rounded),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: wifiList.isLoading
            ? const LoadingSpinner(
                customLoadingMessage: 'Scanning...',
              )
            : DynMouseScroll(
                durationMS: 200,
                animationCurve: Curves.easeOutQuad,
                builder: (context, controller, physics) => ListView.builder(
                  controller: controller,
                  physics: physics,
                  scrollDirection: Axis.horizontal,
                  itemCount: wifiList.value?.length,
                  itemBuilder: (context, index) {
                    final wifi = wifiList.value?[index];
                    return WlanStationTile(
                      ssid: wifi?.ssid ?? 'Unknown',
                      signalStrength: wifi?.signalStrength ?? 0,
                      isConnected: wifi?.isConnected ?? false,
                    );
                  },
                ).animate().fadeIn(duration: 500.ms).slideX(
                      begin: 0.2,
                      end: 0,
                      duration: 500.ms,
                      curve: Curves.easeOutExpo,
                    ),
              ),
      ),
    );
  }
}

class WlanStationTile extends ConsumerWidget {
  const WlanStationTile({required this.ssid, required this.signalStrength, required this.isConnected, super.key});

  final String ssid;
  final int signalStrength;
  final bool isConnected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final panelHeight = ref.watch(layerShellLogicProvider).value!.panelHeight.toDouble();
    final panelWidth = ref.watch(layerShellLogicProvider).value!.panelWidth;

    return SizedBox(
      width: panelWidth / 6,
      height: panelHeight,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.bottomToTop,
              duration: const Duration(milliseconds: 100),
              reverseDuration: const Duration(milliseconds: 120),
              curve: Curves.easeOutExpo,
              child: ConnectionSubmenu(
                ssid: ssid,
              ),
            ),
          );
        },
        child: Card(
          color: isConnected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondaryContainer,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const Gap(4),
                Icon(
                  signalStrength > 75
                      ? Icons.network_wifi_rounded
                      : signalStrength > 50
                          ? Icons.network_wifi_3_bar_rounded
                          : signalStrength > 25
                              ? Icons.network_wifi_2_bar_rounded
                              : Icons.network_wifi_1_bar_rounded,
                  color: isConnected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSecondaryContainer,
                  size: panelHeight / 3,
                ),
                const Gap(8),
                Expanded(
                  child: Text(
                    ssid,
                    style: TextStyle(
                      color: isConnected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSecondaryContainer,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConnectionSubmenu extends HookConsumerWidget {
  const ConnectionSubmenu({required this.ssid, super.key});

  final String ssid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordCtl = useTextEditingController();
    final isPasswordObscured = useState(true);
    final isLoading = useState(false);
    final panelHeight = ref.watch(layerShellLogicProvider).value!.panelHeight;
    final panelWidth = ref.watch(layerShellLogicProvider).value!.panelWidth.toDouble();

    return Submenu(
      title: 'Connect to $ssid',
      body: Row(
        children: [
          Container(
            width: panelWidth / 4,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              controller: passwordCtl,
              style: TextStyle(fontSize: panelHeight / 3),
              obscureText: isPasswordObscured.value,
              decoration: InputDecoration(
                hintText: 'Enter password',
                isDense: true,
                contentPadding: const EdgeInsets.all(8),
                suffix: InkWell(
                  onTapDown: (_) {
                    isPasswordObscured.value = false;
                  },
                  onTapUp: (_) {
                    isPasswordObscured.value = true;
                  },
                  onTapCancel: () {
                    isPasswordObscured.value = true;
                  },
                  child: Icon(
                    isPasswordObscured.value ? Icons.visibility_off : Icons.visibility,
                    size: panelHeight / 2.5,
                  ),
                ),
              ),
              onSubmitted: (value) {
                connect(isLoading, context, ref, ssid, passwordCtl);
              },
            ),
          ),
          TextButton(
            onPressed: isLoading.value ? null : () => connect(isLoading, context, ref, ssid, passwordCtl),
            child: const Text('Connect'),
          ),
          const Gap(8),
          if (isLoading.value)
            const LoadingSpinner(
              customLoadingMessage: 'Connecting...',
            ),
        ],
      ),
    );
  }

  Future<void> connect(ValueNotifier<bool> isLoading, BuildContext context, WidgetRef ref, String ssid,
      TextEditingController passwordCtl,) async {
    isLoading.value = true;
    if (context.mounted) {
      try {
        final result = await connectToWifi(ssid: ssid, password: passwordCtl.value.text);
        if (result) {
          showToast(ref: ref, context: context, message: 'Connected to $ssid', icon: Icons.check_circle);
          unawaited(ref.read(wifiListProvider.notifier).scanWifi());
          Future.delayed(toastDuration + const Duration(milliseconds: 500), () {
            Navigator.pop(context);
          });
        } else {
          showToast(ref: ref, context: context, message: 'Failed to connect to $ssid', icon: Icons.error);
        }

        isLoading.value = false;
      } catch (e) {
        showToast(ref: ref, context: context, message: 'Failed to connect, wrong password?', icon: Icons.error);
        isLoading.value = false;
      }
    }
  }
}
