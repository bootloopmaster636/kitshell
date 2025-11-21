import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kitshell/etc/component/custom_inkwell.dart';
import 'package:kitshell/etc/utitity/dart_extension.dart';
import 'package:kitshell/etc/utitity/gap.dart';
import 'package:kitshell/i18n/strings.g.dart';
import 'package:kitshell/logic/panel_components/quick_settings/internet/wlan/wlan_bloc.dart';
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
                      delay: Duration(milliseconds: 40 * idx),
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

class ApTileCollapsed extends StatelessWidget {
  const ApTileCollapsed({required this.apDetail, super.key});
  final AccessPoint apDetail;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: Gaps.sm.value,
      children: [
        Icon(
          switch (apDetail.strength) {
            >= 0 && <= 25 => LucideIcons.wifiZero,
            > 25 && <= 50 => LucideIcons.wifiLow,
            > 50 && < 75 => LucideIcons.wifiHigh,
            >= 75 && <= 100 => LucideIcons.wifi,
            _ => LucideIcons.circleQuestionMark,
          },
          size: 20,
          color: apDetail.isActive
              ? context.colorScheme.primary
              : context.colorScheme.onSurface,
        ),
        Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              apDetail.ssid,
              style: context.textTheme.titleMedium?.copyWith(
                color: apDetail.isActive
                    ? context.colorScheme.primary
                    : context.colorScheme.onSurface,
              ),
            ),
            ApCapabilities(apDetail: apDetail),
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
    final connectAuto = useState(true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Gaps.md.value,
      children: [
        // AP name and info
        ApTileCollapsed(apDetail: apDetail),

        // AP details
        Container(
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerLow,
            borderRadius: .circular(8),
          ),
          padding: const .all(8),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              Text(
                t.quickSettings.internet.wifi.signalStrength(
                  val: apDetail.strength,
                ),
                style: context.textTheme.bodyMedium,
              ),
            ],
          ),
        ),

        // Connect/disconnect button
        Row(
          children: [
            const Spacer(),
            FilledButton(
              onPressed: () {
                final wlanBloc = BlocProvider.of<WlanBloc>(context);
                if (apDetail.isActive) {
                  wlanBloc.add(const WlanEventDisconnect());
                } else {
                  wlanBloc.add(
                    WlanEventConnect(
                      apPath: apDetail.apPath,
                      ssid: apDetail.ssid,
                    ),
                  );
                }
              },
              child: Text(
                apDetail.isActive
                    ? t.quickSettings.internet.general.disconnect
                    : t.quickSettings.internet.general.connect,
              ),
            ),
          ],
        ),
      ],
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
          if (apDetail.isActive)
            _capabilityBuilder(
              context,
              t.quickSettings.internet.wifi.info.active,
            ),

          if (apDetail.rsnSecurityFlag == ApSecurityFlag.none &&
              apDetail.wpaSecurityFlag == ApSecurityFlag.none)
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
