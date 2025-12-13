import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kitshell/etc/component/custom_inkwell.dart';
import 'package:kitshell/etc/component/text_icon.dart';
import 'package:kitshell/etc/utitity/dart_extension.dart';
import 'package:kitshell/etc/utitity/gap.dart';
import 'package:kitshell/i18n/strings.g.dart';
import 'package:kitshell/logic/panel_components/quick_settings/internet/wlan/wlan_bloc.dart';
import 'package:kitshell/logic/panel_components/quick_settings/internet/wlan/wlan_tools.dart';
import 'package:kitshell/src/rust/api/quick_settings/network/wlan.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class WlanDetails extends HookWidget {
  const WlanDetails({required this.wlanBloc, super.key});
  final WlanBloc wlanBloc;

  @override
  Widget build(BuildContext context) {
    final openedIdx = useState(-1);
    final _ = useMemoized(() async {
      await Future<void>.delayed(Durations.long1);
      wlanBloc.add(const WlanEventScanned());
      return () {};
    }, []);

    return BlocProvider.value(
      value: wlanBloc,
      child: BlocBuilder<WlanBloc, WlanState>(
        builder: (context, state) {
          return ExpansionTile(
            backgroundColor: context.colorScheme.surface,
            title: Text(t.quickSettings.internet.devType.wifi),
            subtitle: Text(state.iface),
            trailing: Row(
              mainAxisSize: .min,
              children: [
                IconButton(
                  onPressed: () {
                    wlanBloc.add(const WlanEventScanned());
                  },
                  icon: const Icon(
                    LucideIcons.refreshCw,
                    size: 16,
                  ),
                ),
                Switch(value: true, onChanged: (val) {}),
              ],
            ),
            initiallyExpanded: true,
            childrenPadding: .zero,
            children: [
              Container(
                height: Gaps.xxs.value,
                color: context.colorScheme.surfaceContainer,
              ),
              if (state.isScanning) const LinearProgressIndicator(),
              ...state.accessPoints.indexed.map((data) {
                final (idx, ap) = data;
                return Container(
                      decoration: BoxDecoration(
                        color: context.colorScheme.surfaceContainer,
                      ),
                      padding: const .only(bottom: 2),
                      child: AccessPointTile(
                        apDetail: ap,
                        openedIdx: openedIdx,
                        idx: idx,
                      ),
                    )
                    .animate(
                      key: ValueKey(ap),
                    )
                    .fadeIn();
              }),
            ],
          );
        },
      ),
    );
  }
}

class AccessPointTile extends StatelessWidget {
  const AccessPointTile({
    required this.apDetail,
    required this.openedIdx,
    required this.idx,
    super.key,
  });
  final AccessPoint apDetail;
  final ValueNotifier<int> openedIdx;
  final int idx;

  @override
  Widget build(BuildContext context) {
    return CustomInkwell(
      onTap: () {
        if (openedIdx.value != idx) {
          openedIdx.value = idx;
        } else {
          openedIdx.value = -1;
        }
      },
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: .circular(4),
      ),
      padding: const .all(16),
      child: AnimatedCrossFade(
        duration: Durations.medium1,
        sizeCurve: Easing.standard,
        crossFadeState: openedIdx.value != idx ? .showFirst : .showSecond,
        firstChild: ApTileCollapsed(apDetail: apDetail),
        secondChild: ApTileExpanded(apDetail: apDetail),
      ),
    );
  }
}

class ApTileCollapsed extends HookWidget {
  const ApTileCollapsed({required this.apDetail, super.key});
  final AccessPoint apDetail;

  @override
  Widget build(BuildContext context) {
    final icon = useMemoized(() {
      return switch (apDetail.strength) {
        >= 0 && <= 25 => LucideIcons.wifiZero,
        > 25 && <= 50 => LucideIcons.wifiLow,
        > 50 && < 75 => LucideIcons.wifiHigh,
        >= 75 && <= 100 => LucideIcons.wifi,
        _ => LucideIcons.circleQuestionMark,
      };
    }, [apDetail.strength]);
    final ssid = useMemoized(() => apDetail.ssid, [apDetail.ssid]);
    final isActive = useMemoized(() => apDetail.isActive, [apDetail.isActive]);

    return Row(
      spacing: Gaps.sm.value,
      children: [
        Icon(
          icon,
          size: 20,
          color: isActive
              ? context.colorScheme.primary
              : context.colorScheme.onSurface,
        ),
        Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              ssid,
              style: context.textTheme.titleMedium?.copyWith(
                color: isActive
                    ? context.colorScheme.primary
                    : context.colorScheme.onSurface,
              ),
            ),
            ApCapabilities(key: ValueKey(apDetail), apDetail: apDetail),
          ],
        ),
      ],
    );
  }
}

class ApTileExpanded extends HookWidget {
  const ApTileExpanded({required this.apDetail, super.key});
  final AccessPoint apDetail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Gaps.sm.value,
      children: [
        // AP name and info
        ApTileCollapsed(apDetail: apDetail),

        // AP details
        Container(
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerLow,
            borderRadius: .circular(8),
          ),
          padding: const .all(16),
          child: ApAdditionalInfo(apDetail: apDetail),
        ),

        ApConnectForm(apDetail: apDetail),
      ],
    );
  }
}

class ApAdditionalInfo extends StatelessWidget {
  const ApAdditionalInfo({required this.apDetail, super.key});
  final AccessPoint apDetail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Text(
          t.quickSettings.internet.wifi.signalStrength(
            val: apDetail.strength,
          ),
          style: context.textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class ApConnectForm extends HookWidget {
  const ApConnectForm({required this.apDetail, super.key});
  final AccessPoint apDetail;

  @override
  Widget build(BuildContext context) {
    final showPasswordField = useState(false);

    return AnimatedCrossFade(
      crossFadeState: showPasswordField.value ? .showFirst : .showSecond,
      duration: Durations.medium1,
      sizeCurve: Easing.standard,
      firstChild: WifiPasswordEntry(
        showPasswordField: showPasswordField,
        apDetail: apDetail,
      ),
      secondChild: WifiRegularConnectButton(
        apDetail: apDetail,
        showPasswordField: showPasswordField,
      ),
    );
  }
}

class WifiRegularConnectButton extends HookWidget {
  const WifiRegularConnectButton({
    required this.apDetail,
    required this.showPasswordField,
    super.key,
  });
  final AccessPoint apDetail;
  final ValueNotifier<bool> showPasswordField;

  @override
  Widget build(BuildContext context) {
    final autoConnect = useState(apDetail.settings?.autoconnect ?? true);

    return Row(
      spacing: Gaps.sm.value,
      children: [
        TextIcon(
          icon: Checkbox(
            value: autoConnect.value,
            onChanged: (val) {
              autoConnect.value = val ?? true;
            },
          ),
          text: Text(t.quickSettings.internet.wifi.connectAuto),
          spacing: 0,
        ),
        const Spacer(),
        BlocBuilder<WlanBloc, WlanState>(
          builder: (context, state) {
            final enableButton =
                state.devState == .activated || state.devState == .disconnected;

            return FilledButton(
              onPressed: enableButton
                  ? () {
                      final wlanBloc = BlocProvider.of<WlanBloc>(context);

                      // If AP is active, disconnect instead
                      if (apDetail.isActive) {
                        wlanBloc.add(const WlanEventDisconnect());
                        return;
                      }

                      // If wifi is unknown and is not open, show password field instead
                      if (!apDetail.isSaved &&
                          !isAccessPointOpen(
                            wpaFlag: apDetail.wpaSecurityFlag,
                            rsnFlag: apDetail.rsnSecurityFlag,
                            isFlagPrivacy: apDetail.apFlagsPrivacy,
                          )) {
                        showPasswordField.value = true;
                        return;
                      }

                      // Connect to known/open wifi
                      wlanBloc.add(
                        WlanEventConnect(
                          apPath: apDetail.apPath,
                          ssid: apDetail.ssid,
                          isKnown: apDetail.isSaved,
                        ),
                      );
                    }
                  : null,
              child: Text(
                apDetail.isActive
                    ? t.quickSettings.internet.general.disconnect
                    : t.quickSettings.internet.general.connect,
              ),
            );
          },
        ),
      ],
    );
  }
}

class WifiPasswordEntry extends HookWidget {
  const WifiPasswordEntry({
    required this.showPasswordField,
    required this.apDetail,
    super.key,
  });
  final ValueNotifier<bool> showPasswordField;
  final AccessPoint apDetail;

  @override
  Widget build(BuildContext context) {
    final isObscured = useState(true);
    final passwordCtl = useTextEditingController();

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
        borderRadius: .circular(8),
      ),
      padding: const .all(16),
      child: Column(
        spacing: Gaps.md.value,
        children: [
          Text(t.quickSettings.internet.wifi.passwordRequired),

          TextField(
            controller: passwordCtl,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              label: Text(t.quickSettings.internet.wifi.passwordLabel),
              suffixIcon: Padding(
                padding: const .only(right: 8),
                child: IconButton(
                  iconSize: 16,
                  onPressed: () {
                    isObscured.value = !isObscured.value;
                  },
                  icon: Icon(
                    isObscured.value ? LucideIcons.eyeOff : LucideIcons.eye,
                  ),
                ),
              ),
            ),
            obscureText: isObscured.value,
          ),

          BlocBuilder<WlanBloc, WlanState>(
            builder: (context, state) {
              final enableButton =
                  state.devState == .activated ||
                  state.devState == .disconnected;

              return Row(
                spacing: Gaps.sm.value,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: enableButton
                          ? () {
                              showPasswordField.value = false;
                            }
                          : null,
                      child: Text(t.general.cancel),
                    ),
                  ),
                  Expanded(
                    child: FilledButton(
                      onPressed: enableButton
                          ? () {
                              BlocProvider.of<WlanBloc>(context).add(
                                WlanEventConnect(
                                  apPath: apDetail.apPath,
                                  ssid: apDetail.ssid,
                                  isKnown: false,
                                  password: passwordCtl.text,
                                ),
                              );
                              showPasswordField.value = false;
                            }
                          : null,
                      child: Text(t.quickSettings.internet.general.connect),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class ApCapabilities extends StatelessWidget {
  const ApCapabilities({required this.apDetail, super.key});
  final AccessPoint apDetail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(top: 2),
      child: Row(
        spacing: Gaps.xs.value,
        children: [
          if (apDetail.isSaved)
            Icon(
              LucideIcons.save,
              size: 12,
              color: context.colorScheme.onSurface,
            ),

          if (apDetail.isActive)
            _capabilityBuilder(
              context,
              t.quickSettings.internet.wifi.info.active,
            ),

          if (isAccessPointOpen(
            wpaFlag: apDetail.wpaSecurityFlag,
            rsnFlag: apDetail.rsnSecurityFlag,
            isFlagPrivacy: apDetail.apFlagsPrivacy,
          ))
            _capabilityBuilder(
              context,
              t.quickSettings.internet.wifi.info.open,
            ),

          switch (apDetail.frequency) {
            WifiFreq.freq5Ghz => _capabilityBuilder(
              context,
              t.quickSettings.internet.wifi.info.freq5g,
            ),
            WifiFreq.freq6Ghz => _capabilityBuilder(
              context,
              t.quickSettings.internet.wifi.info.freq6g,
            ),
            WifiFreq.freq24Ghz ||
            WifiFreq.freqUnknown => const SizedBox.shrink(),
          },
        ],
      ),
    );
  }

  Widget _capabilityBuilder(BuildContext context, String text) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.tertiaryContainer,
        borderRadius: .circular(4),
      ),
      padding: const .symmetric(horizontal: 4),
      child: Text(
        text,
        style: context.textTheme.labelMedium?.copyWith(
          color: context.colorScheme.onTertiaryContainer,
        ),
      ),
    );
  }
}
