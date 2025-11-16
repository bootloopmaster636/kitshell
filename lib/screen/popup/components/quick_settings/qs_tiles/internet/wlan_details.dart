import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitshell/etc/utitity/dart_extension.dart';
import 'package:kitshell/i18n/strings.g.dart';
import 'package:kitshell/logic/panel_components/quick_settings/internet/wlan/wlan_bloc.dart';
import 'package:kitshell/src/rust/api/quick_settings/network/wlan.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class WlanDetails extends StatelessWidget {
  const WlanDetails({required this.wlanBloc, super.key});
  final WlanBloc wlanBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => wlanBloc,
      child: BlocBuilder<WlanBloc, WlanState>(
        bloc: wlanBloc,
        builder: (context, state) {
          return ExpansionTile(
            backgroundColor: context.colorScheme.surface,
            leading: const Icon(LucideIcons.wifi),
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
              if (state.isScanning) const LinearProgressIndicator(),
              ...state.accessPoints.map(
                (e) => AccessPointTile(apDetail: e),
              ),
            ],
          );
        },
      ),
    );
  }
}

class AccessPointTile extends StatelessWidget {
  const AccessPointTile({required this.apDetail, super.key});
  final AccessPoint apDetail;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(apDetail.ssid),
      ),
    );
  }
}
