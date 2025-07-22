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
              icon: Ic.outline_brightness_medium,
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

            return QsProgressBarComponent(
              title: t.quickSettings.battery.title,
              subtitle: switch (info.isCharging) {
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
              icon: Ic.twotone_battery_50,
              value: info.capacity.toInt(),
              maxVal: 100,
            );
          }).toList(),
        );
      },
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
  final String icon;
  final String title;
  final String? subtitle;
  final int maxVal;
  final int value;
  final void Function(double)? onValueChanged;

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);
    final memoizedVal = useMemoized(() => getPercent(value, maxVal), [value]);
    final memoizedDoubleVal = useMemoized(value.toDouble, [
      value,
    ]);
    final memoizedDoubleMaxVal = useMemoized(maxVal.toDouble, [maxVal]);

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: AnimatedContainer(
        duration: Durations.short2,
        decoration: BoxDecoration(
          color: isHovered.value
              ? context.colorScheme.surfaceContainerLowest
              : context.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            if (isHovered.value)
              BoxShadow(
                color: context.colorScheme.shadow.withValues(alpha: 0.2),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Gaps.xs.value,
          children: [
            Row(
              children: [
                TextIcon(
                  icon: Iconify(
                    icon,
                    size: 20,
                    color: context.colorScheme.primary,
                  ),
                  text: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: context.textTheme.bodyMedium),
                      if (subtitle != null)
                        Text(subtitle!, style: context.textTheme.bodySmall),
                    ],
                  ),
                ),
                const Spacer(),
                AnimatedFlipCounter(
                  duration: Durations.short2,
                  curve: Easing.standardDecelerate,
                  value: memoizedVal,
                  textStyle: context.textTheme.bodyLarge,
                ),
              ],
            ),
            Slider(
              value: memoizedDoubleVal,
              max: memoizedDoubleMaxVal,
              onChanged: onValueChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class QsProgressBarComponent extends HookWidget {
  const QsProgressBarComponent({
    required this.icon,
    required this.title,
    required this.value,
    required this.maxVal,
    this.subtitle,
    super.key,
  });
  final String icon;
  final String title;
  final String? subtitle;
  final int value;
  final int maxVal;

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);
    final normalizedValue = useMemoized(() => getNormalized(value, maxVal), [
      value,
    ]);

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: AnimatedContainer(
        duration: Durations.short2,
        decoration: BoxDecoration(
          color: isHovered.value
              ? context.colorScheme.surfaceContainerLowest
              : context.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            if (isHovered.value)
              BoxShadow(
                color: context.colorScheme.shadow.withValues(alpha: 0.2),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            TextIcon(
              icon: Iconify(
                icon,
                size: 20,
                color: context.colorScheme.primary,
              ),
              text: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.textTheme.bodyMedium),
                  if (subtitle != null)
                    Text(subtitle!, style: context.textTheme.bodySmall),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 72,
              child: LinearProgressIndicator(value: normalizedValue),
            ),
            Gaps.md.gap,
            AnimatedFlipCounter(
              duration: Durations.short2,
              curve: Easing.standardDecelerate,
              value: value,
              textStyle: context.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
