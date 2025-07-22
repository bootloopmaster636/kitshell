import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:kitshell/etc/component/clickable_panel_component.dart';
import 'package:kitshell/etc/component/panel_enum.dart';
import 'package:kitshell/etc/utitity/dart_extension.dart';
import 'package:kitshell/etc/utitity/hooks/callback_debounce_hook.dart';
import 'package:kitshell/etc/utitity/math.dart';
import 'package:kitshell/injectable.dart';
import 'package:kitshell/logic/panel_components/quick_settings/battery/qs_battery_bloc.dart';
import 'package:kitshell/logic/panel_components/quick_settings/brightness/qs_brightness_bloc.dart';
import 'package:kitshell/screen/panel/panel.dart';
import 'package:kitshell/src/rust/api/quick_settings/battery.dart';

class StatusbarComponent extends HookWidget {
  const StatusbarComponent({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize qs/statusbar feature watcher
    useEffect(() {
      get<QsBrightnessBloc>().add(const QsBrightnessEventStarted());
      get<QsBatteryBloc>().add(const QsBatteryEventStarted());
      return () {};
    }, []);

    return ClickablePanelComponent(
      content: const StatusbarContent(),
      popupPosition: InheritedAlignment.of(context).position,
      popupToShow: PopupWidget.quickSettings,
    );
  }
}

class StatusbarContent extends StatelessWidget {
  const StatusbarContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        BrightnessStatus(),
        BatteryStatus(),
      ],
    );
  }
}

class BrightnessStatus extends StatelessWidget {
  const BrightnessStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QsBrightnessBloc, QsBrightnessState>(
      bloc: get<QsBrightnessBloc>(),
      builder: (context, state) {
        if (state is! QsBrightnessStateLoaded) return const SizedBox();
        final firstBrightness = state.brightness.first;

        // Determine icon to show
        const iconList = [
          Ic.twotone_brightness_1,
          Ic.twotone_brightness_2,
          Ic.twotone_brightness_3,
          Ic.twotone_brightness_4,
          Ic.twotone_brightness_5,
          Ic.twotone_brightness_6,
          Ic.twotone_brightness_7,
        ];
        final brightnessValue = getPercent(
          firstBrightness.brightness,
          firstBrightness.maxBrightness,
        );

        return StatusComponent(
          icon: getIconFromValue(iconList, brightnessValue),
          value: brightnessValue,
        );
      },
    );
  }
}

class BatteryStatus extends StatelessWidget {
  const BatteryStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QsBatteryBloc, QsBatteryState>(
      bloc: get<QsBatteryBloc>(),
      builder: (context, state) {
        if (state is! QsBatteryStateLoaded) return const SizedBox();
        final firstBattery = state.batteryInfos.first;

        const iconList = [
          Ic.twotone_battery_0_bar,
          Ic.twotone_battery_1_bar,
          Ic.twotone_battery_3_bar,
          Ic.twotone_battery_4_bar,
          Ic.twotone_battery_5_bar,
          Ic.twotone_battery_6_bar,
          Ic.twotone_battery_std,
        ];

        return StatusComponent(
          icon: getIconFromValue(iconList, firstBattery.capacity.toInt()),
          value: firstBattery.capacity.toInt(),
          cornerIcon: firstBattery.isCharging == BatteryState.charging
              ? Ic.round_bolt
              : null,
        );
      },
    );
  }
}

class StatusComponent extends HookWidget {
  const StatusComponent({
    required this.icon,
    this.value,
    this.cornerIcon,
    super.key,
  });
  final String icon;
  final int? value;
  final String? cornerIcon;

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);
    useCallbackDebounced(
      duration: 1500.ms,
      keys: [value ?? 0],
      onStart: () => isHovered.value = true,
      onEnd: () => isHovered.value = false,
    );

    return SizedBox(
      height: 32,
      width: 24,
      child: MouseRegion(
        onEnter: (_) => isHovered.value = true,
        onExit: (_) => isHovered.value = false,
        child: Stack(
          children: [
            Center(
              child: Iconify(
                icon,
                color: isHovered.value
                    ? context.colorScheme.tertiary
                    : context.colorScheme.onSurface,
                size: 16,
              ),
            ),
            if (value != null)
              Align(
                alignment: Alignment.topRight,
                child:
                    Container(
                          width: 16,
                          height: 14,
                          decoration: BoxDecoration(
                            color: context.colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            value.toString(),
                            style: context.textTheme.labelSmall?.copyWith(
                              fontSize: 8,
                              color: context.colorScheme.onPrimary,
                            ),
                          ),
                        )
                        .animate(target: isHovered.value ? 1 : 0)
                        .scaleXY(
                          duration: Durations.short4,
                          curve: Easing.standard,
                        ),
              ),
            if (cornerIcon != null)
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Iconify(
                    cornerIcon!,
                    color: context.colorScheme.secondary,
                    size: 10,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
