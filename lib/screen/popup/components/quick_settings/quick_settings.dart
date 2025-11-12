import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hero_container/hero_container.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/carbon.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:kitshell/etc/component/custom_inkwell.dart';
import 'package:kitshell/etc/component/large_slider.dart';
import 'package:kitshell/etc/component/text_icon.dart';
import 'package:kitshell/etc/utitity/config.dart';
import 'package:kitshell/etc/utitity/dart_extension.dart';
import 'package:kitshell/etc/utitity/gap.dart';
import 'package:kitshell/etc/utitity/math.dart';
import 'package:kitshell/i18n/strings.g.dart';
import 'package:kitshell/injectable.dart';
import 'package:kitshell/logic/panel_components/quick_settings/battery/qs_battery_bloc.dart';
import 'package:kitshell/logic/panel_components/quick_settings/brightness/qs_brightness_bloc.dart';
import 'package:kitshell/src/rust/api/quick_settings/battery.dart';
import 'package:kitshell/src/rust/api/quick_settings/display_brightness.dart';
import 'package:kitshell/src/rust/api/quick_settings/whoami.dart';

part 'quick_settings_component.dart';

class QuickSettingsPopup extends StatelessWidget {
  const QuickSettingsPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer.withValues(
          alpha: popupBgOpacity,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: const QuickSettingsMainScreen(),
    );
  }
}

class QuickSettingsMainScreen extends StatelessWidget {
  const QuickSettingsMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const QsHeader(),
        Padding(
          padding: const EdgeInsets.all(8).copyWith(top: 0),
          child: Container(
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: context.colorScheme.shadow.withValues(alpha: 0.2),
                  blurRadius: 2,
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            padding: const EdgeInsets.all(12),
            child: const QsContent(),
          ),
        ),
      ],
    );
  }
}

class QsContent extends HookWidget {
  const QsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final test = useState(false);
    return Column(
      children: [
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: Gaps.sm.value,
          crossAxisSpacing: Gaps.sm.value,
          childAspectRatio: 3,
          shrinkWrap: true,
          children: [
            QsTile(
              icon: Carbon.wifi,
              text: 'Wi-Fi',
              onAction: () {
                test.value = !test.value;
              },
              openedChild: const Placeholder(),
              active: test.value,
            ),
            QsTile(
              icon: Carbon.bluetooth,
              text: 'Bluetooth',
              onAction: () {},
            ),
          ],
        ),
        Gaps.md.gap,
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BrightnessSlider(),
          ],
        ),
        Gaps.sm.gap,
        Container(
          height: 32,
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: const Row(
            children: [BatteryProgress()],
          ),
        ),
      ],
    );
  }
}

class QsTile extends StatelessWidget {
  const QsTile({
    required this.icon,
    required this.text,
    required this.onAction,
    this.subText,
    this.openedChild,
    this.active,
    super.key,
  });

  /// Feature icon to be displayed on the left side
  final String icon;

  /// Feature name
  final String text;

  /// Feature's additional text
  final String? subText;

  /// Function to run when clicking on QS tile
  final VoidCallback onAction;

  /// Widget to open when clicking on 'more button'
  /// If null, the feature does not support more action
  final Widget? openedChild;

  /// Whether the feature is active.
  /// If this is null, the feature does not support switching
  final bool? active;

  @override
  Widget build(BuildContext context) {
    return HeroContainer(
      transitionDuration: Durations.long3,
      transitionCurve: Curves.easeInOutCubicEmphasized,
      closedElevation: 0,
      openedElevation: 0,
      closedAlignment: Alignment.center,
      openedAlignemnt: Alignment.center,
      closedColor: Colors.transparent,
      openedColor: Colors.transparent,
      closedFit: BoxFit.contain,
      openedFit: BoxFit.cover,
      closedBuilder: (BuildContext context, void Function() openMoreSetting) =>
          QsTileComponent(
            icon: icon,
            onAction: onAction,
            openMoreSetting: openMoreSetting,
            text: text,
            active: active,
            openedChild: openedChild,
            subText: subText,
          ),
      openedBuilder: (BuildContext context) => QsMoreSettings(
        moreSettingPage: openedChild ?? const Placeholder(),
        title: text,
      ),
    );
  }
}

class QsTileComponent extends HookWidget {
  const QsTileComponent({
    required this.icon,
    required this.text,
    required this.onAction,
    required this.openMoreSetting,
    this.subText,
    this.openedChild,
    this.active,
    super.key,
  });

  /// Feature icon to be displayed on the left side
  final String icon;

  /// Feature name
  final String text;

  /// Feature's additional text
  final String? subText;

  /// Function to run when clicking on QS tile
  final VoidCallback onAction;

  /// Widget to open when clicking on 'more button'
  /// If null, the feature does not support more action
  final Widget? openedChild;

  /// Whether the feature is active.
  /// If this is null, the feature does not support switching
  final bool? active;

  /// Function to trigger more setting
  final VoidCallback openMoreSetting;

  @override
  Widget build(BuildContext context) {
    final animationCtl = useAnimationController(duration: Durations.short4);
    final animation = useAnimation(
      animationCtl.drive(CurveTween(curve: Curves.easeInOutQuad)),
    );

    final _ = useMemoized(() async {
      if (active ?? false) {
        await animationCtl.forward();
      } else {
        await animationCtl.reverse();
      }
    }, [active]);

    return CustomInkwell(
      onTap: onAction.call,
      onLongPress: () {
        if (openedChild == null) return;
        openMoreSetting.call();
      },
      decoration: BoxDecoration(
        color: Color.lerp(
          context.colorScheme.surfaceContainer,
          context.colorScheme.primary,
          animation,
        ),
        borderRadius: BorderRadius.lerp(
          BorderRadius.circular(48),
          BorderRadius.circular(8),
          animation,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            color: context.colorScheme.shadow.withValues(
              alpha: 0.2,
            ),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.none,
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          // Main action button
          Expanded(
            flex: 3,
            child: Padding(
              padding:
                  EdgeInsets.lerp(
                    const EdgeInsets.only(left: 16, right: 8),
                    const EdgeInsets.only(left: 12, right: 8),
                    animation,
                  ) ??
                  EdgeInsets.zero,
              child: TextIcon(
                icon: Iconify(
                  icon,
                  color: Color.lerp(
                    context.colorScheme.onSurfaceVariant,
                    context.colorScheme.onPrimary,
                    animation,
                  ),
                ),
                text: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: Color.lerp(
                          context.colorScheme.onSurfaceVariant,
                          context.colorScheme.onPrimary,
                          animation,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subText != null)
                      Text(
                        subText!,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: Color.lerp(
                            context.colorScheme.onSurfaceVariant,
                            context.colorScheme.onPrimary,
                            animation,
                          ),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ),
          ),

          // More setting button
          if (openedChild != null)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: CustomInkwell(
                  width: 32,
                  height: 40,
                  onTap: openMoreSetting.call,
                  decoration: BoxDecoration(
                    color: active ?? false
                        ? context.colorScheme.secondaryContainer
                        : context.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Iconify(
                    Ic.chevron_right,
                    color: active ?? false
                        ? context.colorScheme.onSecondaryContainer
                        : context.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          Gaps.sm.gap,
        ],
      ).animate(),
    );
  }
}

class QsMoreSettings extends StatelessWidget {
  const QsMoreSettings({
    required this.moreSettingPage,
    required this.title,
    super.key,
  });

  final String title;
  final Widget moreSettingPage;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        height: 500,
        width: 400,
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainer,
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          spacing: Gaps.sm.value,
          children: [
            // Header
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Iconify(
                    Ic.arrow_back,
                    color: context.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                Expanded(
                  child: Text(
                    title,
                    style: context.textTheme.titleLarge,
                  ),
                ),
              ],
            ),

            // Content
            Expanded(child: moreSettingPage),
          ],
        ),
      ),
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
            icon: Iconify(
              Ic.round_power_settings_new,
              size: 20,
              color: context.colorScheme.onSurfaceVariant,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
