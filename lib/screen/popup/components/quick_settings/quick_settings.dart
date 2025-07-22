import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:kitshell/etc/component/text_icon.dart';
import 'package:kitshell/etc/utitity/dart_extension.dart';
import 'package:kitshell/etc/utitity/gap.dart';
import 'package:kitshell/etc/utitity/math.dart';
import 'package:kitshell/i18n/strings.g.dart';
import 'package:kitshell/injectable.dart';
import 'package:kitshell/logic/panel_components/quick_settings/battery/qs_battery_bloc.dart';
import 'package:kitshell/logic/panel_components/quick_settings/brightness/qs_brightness_bloc.dart';
import 'package:kitshell/logic/panel_components/quick_settings/qs_routing/qs_routing_cubit.dart';
import 'package:kitshell/src/rust/api/quick_settings/battery.dart';
import 'package:kitshell/src/rust/api/quick_settings/display_brightness.dart';
import 'package:kitshell/src/rust/api/quick_settings/whoami.dart';

part 'quick_settings_component.dart';

class QuickSettingsPopup extends StatelessWidget {
  const QuickSettingsPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QsRoutingCubit, QsRoutingState>(
      bloc: get<QsRoutingCubit>(),
      builder: (context, state) {
        return Container(
          width: 380,
          height: 520,
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainer.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.colorScheme.outlineVariant),
          ),
          clipBehavior: Clip.antiAlias,
          child: AnimatedSwitcherPlus.zoomIn(
            duration: Durations.medium3,
            switchInCurve: Curves.easeInOutCubicEmphasized,
            switchOutCurve: Curves.easeInOutCubicEmphasized.flipped,
            scaleInFactor: 0.96,
            scaleOutFactor: 1.04,
            child: state.openedDetailPage ?? const QuickSettingsMainScreen(),
          ),
        );
      },
    );
  }
}

class QuickSettingsMainScreen extends StatelessWidget {
  const QuickSettingsMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const QsHeader(),

        Flexible(
          child: Container(
            decoration: BoxDecoration(color: context.colorScheme.surface),
            padding: const EdgeInsets.all(8),
            child: const QsContent(),
          ),
        ),
      ],
    );
  }
}

class QsContent extends StatelessWidget {
  const QsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Gaps.sm.value,
      children: const [BatteryProgress(), BrightnessSlider()],
    );
  }
}

class QsHeader extends StatelessWidget {
  const QsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const WhoAmI(),
          const Spacer(),
          IconButton(
            icon: const Iconify(Ic.round_power_settings_new, size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
