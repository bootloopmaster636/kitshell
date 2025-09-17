import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bi.dart';
import 'package:kitshell/data/model/runtime/appinfo/appinfo_model.dart';
import 'package:kitshell/data/repository/launchbar/wm_iface_repo.dart';
import 'package:kitshell/etc/component/custom_inkwell.dart';
import 'package:kitshell/etc/component/panel_enum.dart';
import 'package:kitshell/etc/utitity/config.dart';
import 'package:kitshell/etc/utitity/dart_extension.dart';
import 'package:kitshell/etc/utitity/gap.dart';
import 'package:kitshell/i18n/strings.g.dart';
import 'package:kitshell/injectable.dart';
import 'package:kitshell/logic/panel_components/appmenu/appmenu_bloc.dart';
import 'package:kitshell/logic/panel_components/launchbar/launchbar_bloc.dart';
import 'package:kitshell/logic/screen_manager/screen_manager_bloc.dart';
import 'package:kitshell/screen/panel/panel.dart';
import 'package:kitshell/screen/popup/components/appmenu.dart';

class LaunchBar extends HookWidget {
  const LaunchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      get<AppmenuBloc>().add(const AppmenuSubscribed());
      get<AppmenuBloc>().add(AppmenuLoad(locale: t.locale));
      get<LaunchbarBloc>().add(const LaunchbarEventApplistWatched());
      get<LaunchbarBloc>().add(const LaunchbarEventWmEventsWatched());
      return () {};
    }, []);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AppmenuButton(),
        Gaps.sm.gap,
        const LaunchBarPinnedAppsList(),
      ],
    );
  }
}

class AppmenuButton extends HookWidget {
  const AppmenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);
    return CustomInkwell(
      onTap: () {
        get<ScreenManagerBloc>().add(
          ScreenManagerEventOpenPopup(
            popupToShow: PopupWidget.appMenu,
            position: InheritedAlignment.of(context).position,
          ),
        );
      },
      onPointerEnter: (_) => isHovered.value = true,
      onPointerExit: (_) => isHovered.value = false,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Iconify(
        Bi.box_seam,
        color: isHovered.value
            ? context.colorScheme.primary
            : context.colorScheme.onSurface,
      ),
    );
  }
}

class LaunchBarPinnedAppsList extends StatelessWidget {
  const LaunchBarPinnedAppsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LaunchbarBloc, LaunchbarState>(
      bloc: get<LaunchbarBloc>(),
      builder: (context, state) {
        if (state is! LaunchbarStateLoaded) return const SizedBox.shrink();

        return AnimatedSize(
          duration: Durations.medium2,
          curve: Easing.standard,
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ReorderableListView(
              scrollDirection: Axis.horizontal,
              buildDefaultDragHandles: false,
              shrinkWrap: true,
              children: [
                for (int idx = 0; idx < state.items.length; idx++)
                  Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: ReorderableDelayedDragStartListener(
                          enabled: state.items[idx].isPinned,
                          index: idx,
                          child: LaunchbarItemComp(data: state.items[idx]),
                        ),
                      )
                      .animate(key: ValueKey(idx))
                      .scaleXY(
                        begin: 0,
                        end: 1,
                        alignment: Alignment.center,
                        duration: Durations.medium1,
                        curve: Easing.standard,
                      )
                      .fadeIn(duration: Durations.long1),
              ],
              onReorder: (oldIdx, newIdx) => get<LaunchbarBloc>().add(
                LaunchbarEventSwapPinned(oldIdx, newIdx),
              ),
            ),
          ),
        );
      },
    );
  }
}

class LaunchbarItemComp extends HookWidget {
  const LaunchbarItemComp({required this.data, super.key});

  final LaunchbarItem data;

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);
    final isOpened = useMemoized(() => data.windowInfo != null, [
      data.windowInfo,
    ]);
    final isFocused = useMemoized(() => data.windowInfo?.isFocused ?? false, [
      data.windowInfo,
    ]);
    final showTitle = useMemoized(() => false);

    return AnimatedSize(
      duration: Durations.medium1,
      curve: Easing.standard,
      child: CustomInkwell(
        width: showTitle ? 160 : panelDefaultHeightPx.toDouble(),
        height: panelDefaultHeightPx.toDouble(),
        onPointerEnter: (_) => isHovered.value = true,
        onPointerExit: (_) => isHovered.value = false,
        onTap: () {
          if (data.windowInfo != null) {
            get<WmIfaceRepo>().wmFocusWindow(data.windowInfo!.windowId.toInt());
          }
        },
        decoration: BoxDecoration(
          color: isOpened
              ? context.colorScheme.surfaceContainerLow
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: isOpened
              ? Border.all(
                  color: context.colorScheme.outlineVariant,
                )
              : null,
        ),
        padding: EdgeInsets.zero,
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: Gaps.sm.value,
                  children: [
                    AppIcon(
                      icon: data.appInfo?.metadata.iconPath,
                      iconSize: 24,
                    ),
                    if (showTitle)
                      Expanded(
                        child: Text(
                          data.windowInfo?.windowTitle ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (isOpened)
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: Durations.medium1,
                  curve: Easing.standard,
                  width: isFocused ? 32 : 8,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
