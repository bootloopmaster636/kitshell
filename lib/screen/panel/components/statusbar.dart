import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:kitshell/etc/component/clickable_panel_component.dart';
import 'package:kitshell/etc/component/panel_enum.dart';
import 'package:kitshell/etc/utitity/buildcontext_extension.dart';
import 'package:kitshell/etc/utitity/math.dart';
import 'package:kitshell/injectable.dart';
import 'package:kitshell/logic/panel_components/quick_settings/brightness/qs_brightness_bloc.dart';
import 'package:kitshell/screen/panel/panel.dart';

class StatusbarComponent extends HookWidget {
  const StatusbarComponent({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize qs/statusbar feature watcher
    useEffect(() {
      get<QsBrightnessBloc>().add(const QsBrightnessEventStarted());
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

        // Get value
        final brightnessValue = getPercent(
          firstBrightness.brightness,
          firstBrightness.maxBrightness,
        );
        final index = (brightnessValue / 100 * iconList.length)
            .clamp(0, 6)
            .toInt();
        final icon = iconList[index];

        return StatusComponent(
          icon: icon,
          value: brightnessValue,
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
    useValueChanged(value, (_, _) async {
      isHovered.value = true;
      await Future<void>.delayed(1000.ms);
      isHovered.value = false;
    });

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
                child: Iconify(
                  cornerIcon!,
                  color: context.colorScheme.secondary,
                  size: 10,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
