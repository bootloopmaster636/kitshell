part of 'quick_settings.dart';

class BrightnessSlider extends HookWidget {
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
              value: info.brightness.toDouble(),
              maxVal: info.maxBrightness.toDouble(),
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
            color: context.theme.colorScheme.onPrimaryFixed,
          ),
        ),
        Text(
          '${userInfo.data?.username ?? '-'}@${userInfo.data?.hostname ?? '-'}',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.theme.colorScheme.onSecondaryFixed,
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
  final double maxVal;
  final double value;
  final void Function(double)? onValueChanged;

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);
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
                blurRadius: 4,
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
                  value: getPercent(value.toInt(), maxVal.toInt()),
                  textStyle: context.textTheme.bodyLarge,
                ),
              ],
            ),
            Slider(
              value: value,
              max: maxVal,
              onChanged: onValueChanged,
            ),
          ],
        ),
      ),
    );
  }
}
