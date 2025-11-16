import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitshell/i18n/strings.g.dart';
import 'package:kitshell/injectable.dart';
import 'package:kitshell/logic/panel_components/quick_settings/internet/base/internet_cubit.dart';
import 'package:kitshell/screen/popup/components/quick_settings/qs_tiles/internet/wlan_details.dart';
import 'package:kitshell/screen/popup/components/quick_settings/quick_settings.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class InternetQsTile extends StatelessWidget {
  const InternetQsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return QsTile(
      icon: LucideIcons.globe,
      text: t.quickSettings.internet.title,
      openedChild: const InternetQsDetails(),
      active: false,
    );
  }
}

class InternetQsDetails extends StatelessWidget {
  const InternetQsDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetCubit, InternetState>(
      bloc: get<InternetCubit>(),
      builder: (context, state) {
        if (state is! InternetStateLoaded) return const SizedBox();

        return Column(
          children:
              [
                    ...state.wlanDevices.map(
                      (e) => WlanDetails(
                        wlanBloc: e,
                      ),
                    ),
                  ]
                  .map(
                    (w) => Card(
                      elevation: 2,
                      child: w,
                    ),
                  )
                  .toList(),
        );
      },
    );
  }
}
