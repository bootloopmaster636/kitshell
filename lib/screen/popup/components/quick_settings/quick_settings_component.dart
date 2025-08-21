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

        return Column(
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

            return QsMiniProgressComponent(
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
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          userInfo.data?.fullname ?? '-',
          style: context.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
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
  final void Function(double)? onValueChanged;

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);
    return LargeSlider(
      insetIcon: icon,
      label: title,
      onChanged: onValueChanged ?? (val) {},
      value: value.toDouble(),
      maxValue: maxVal.toDouble(),
      textStyle: context.textTheme.bodySmall,
    );
  }
}

class QsMiniProgressComponent extends HookWidget {
  const QsMiniProgressComponent({
    required this.icon,
    this.value,
    this.maxVal,
    this.tooltipText,
    super.key,
  });
  final String icon;
  final String? tooltipText;
  final int? value;
  final int? maxVal;

  @override
  Widget build(BuildContext context) {
    final normalizedValue = useMemoized(
      () => getNormalized(value ?? 0, maxVal ?? 0),
      [
        value,
        maxVal,
      ],
    );

    return CustomInkwell(
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: TextIcon(
        icon: Iconify(
          icon,
          size: 20,
          color: context.colorScheme.primary,
        ),
        spacing: Gaps.xs.value,
        text: Tooltip(
          message: tooltipText,
          child: Column(
            spacing: Gaps.xs.value,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (value != null)
                Text(
                  '${(normalizedValue * 100).toStringAsFixed(0)}%',
                  style: context.textTheme.bodySmall,
                ),
              if (value != null)
                SizedBox(
                  width: 36,
                  child: LinearProgressIndicator(value: normalizedValue),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
