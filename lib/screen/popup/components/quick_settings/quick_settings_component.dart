part of 'quick_settings.dart';

class BrightnessSlider extends StatelessWidget {
  const BrightnessSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QsBrightnessBloc, QsBrightnessState>(
      bloc: get<QsBrightnessBloc>(),
      builder: (context, state) {
        if (state is! QsBrightnessStateLoaded) return const SizedBox();

        return Column(
          children: state.brightness.map((info) {
            return QsSliderComponent(
              icon: Icons.brightness_4_outlined,
              value: info.brightness,
              maxVal: info.maxBrightness,
              onValueChanged: (val) {
                changeBrightness(
                  name: info.name,
                  value: getPercent(val.toInt(), info.maxBrightness),
                );
              },
              title: t.quickSettings.brightness.title,
              subtitle: info.name,
            );
          }).toList(),
        );
      },
    );
  }
}

class BatteryProgress extends StatelessWidget {
  const BatteryProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QsBatteryBloc, QsBatteryState>(
      bloc: get<QsBatteryBloc>(),
      builder: (context, state) {
        if (state is! QsBatteryStateLoaded) return const SizedBox();

        return Row(
          children: state.batteryInfos.map((info) {
            // Count duration from seconds
            final timeToFull = info.timeToFullSecs != null
                ? Duration(
                    seconds: info.timeToFullSecs!.toInt(),
                  )
                : null;
            final timeToEmpty = info.timeToEmptySecs != null
                ? Duration(
                    seconds: info.timeToEmptySecs!.toInt(),
                  )
                : null;

            return QsMiniStatusComponent(
              tooltipText: switch (info.battState) {
                BatteryState.unknown => '',
                BatteryState.charging =>
                  '${t.quickSettings.battery.status.charging} '
                      '(${t.quickSettings.battery.estimation.remaining(time: timeToFull?.toHoursMinutes() ?? '')})',
                BatteryState.discharging =>
                  '${t.quickSettings.battery.status.discharging} '
                      '(${t.quickSettings.battery.estimation.remaining(time: timeToEmpty?.toHoursMinutes() ?? '')})',
                BatteryState.empty => t.quickSettings.battery.status.empty,
                BatteryState.full => t.quickSettings.battery.status.full,
              },
              icon: Ic.baseline_battery_5_bar,
              value: info.capacity.toInt(),
              maxVal: 100,
            );
          }).toList(),
        );
      },
    );
  }
}

class PlaceholderSlider extends HookWidget {
  const PlaceholderSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final value = useState(50);
    return QsSliderComponent(
      icon: Icons.volume_up_outlined,
      value: value.value,
      maxVal: 100,
      onValueChanged: (val) {
        value.value = val.toInt();
      },
      title: 'Placeholder',
    );
  }
}

class WhoAmI extends HookWidget {
  const WhoAmI({super.key});

  @override
  Widget build(BuildContext context) {
    final userInfoFuture = useMemoized(getUserInfo);
    final userInfo = useFuture(userInfoFuture);

    return Column(
      mainAxisAlignment: .center,
      crossAxisAlignment: .start,
      children: [
        Text(
          userInfo.data?.fullname ?? '-',
          style: context.textTheme.bodyLarge?.copyWith(
            fontWeight: .bold,
            color: context.theme.colorScheme.primary,
          ),
        ),
        Text(
          '${userInfo.data?.username ?? '-'}@${userInfo.data?.hostname ?? '-'}',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.theme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}

class QsSliderComponent extends HookWidget {
  const QsSliderComponent({
    required this.maxVal,
    required this.onValueChanged,
    required this.icon,
    required this.title,
    required this.value,
    this.subtitle,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final int maxVal;
  final int value;
  final void Function(double) onValueChanged;

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);
    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child:
          LargeSlider(
                insetIcon: icon,
                label: title,
                onChanged: onValueChanged,
                value: value.toDouble(),
                maxValue: maxVal.toDouble(),
                textStyle: context.textTheme.bodySmall,
              )
              .animate(target: isHovered.value ? 1 : 0)
              .scaleXY(
                duration: Durations.short3,
                begin: 1,
                end: 1.02,
                curve: Curves.easeInOutQuad,
              ),
    );
  }
}

class QsMiniStatusComponent extends HookWidget {
  const QsMiniStatusComponent({
    required this.icon,
    required this.value,
    required this.maxVal,
    this.tooltipText,
    super.key,
  });

  final String icon;
  final int value;
  final int maxVal;
  final String? tooltipText;

  @override
  Widget build(BuildContext context) {
    final normalizedValue = useMemoized(
      () => getNormalized(value, maxVal),
      [
        value,
        maxVal,
      ],
    );

    return Tooltip(
      message: tooltipText,
      child: TextIcon(
        spacing: Gaps.xxs.value,
        icon: Iconify(
          icon,
          size: 20,
          color: context.colorScheme.primary,
        ),
        text: Text(
          '${(normalizedValue * 100).toStringAsFixed(0)}%',
          style: context.textTheme.bodySmall,
        ),
      ),
    );
  }
}
