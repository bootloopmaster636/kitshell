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
import 'package:kitshell/screen/panel/components/launchbar/workspace_indicator.dart';
import 'package:kitshell/screen/panel/panel.dart';
import 'package:kitshell/screen/popup/components/appmenu.dart';

class Launchbar extends HookWidget {
  const Launchbar({Key? key}) : super(key: key);

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
      spacing: Gaps.xs.value,
      children: [
        const WorkspaceIndicator(),
        SizedBox(
          height: 24,
          child: VerticalDivider(
            color: context.colorScheme.outlineVariant,
            width: 4,
            radius: BorderRadius.circular(8),
          ),
        ),
        const AppmenuButton(),
        const LaunchbarAppList(),
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

class LaunchbarAppList extends StatelessWidget {
  const LaunchbarAppList({super.key});

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
              clipBehavior: Clip.none,
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
    final isOpened = useMemoized(() => data.windowInfo != null, [
      data.windowInfo,
    ]);
    final isFocused = useMemoized(() => data.windowInfo?.isFocused ?? false, [
      data.windowInfo,
    ]);
    final showTitle = useMemoized(() => isFocused, [
      isFocused,
    ]); // In the future, this will be configurable

    return AnimatedSize(
      duration: Durations.long2,
      curve: Curves.easeOutQuint,
      child: CustomInkwell(
        width: showTitle ? 160 : panelDefaultHeightPx.toDouble(),
        height: panelDefaultHeightPx.toDouble(),
        onTap: () async {
          if (data.windowInfo != null) {
            await get<WmIfaceRepo>().wmFocusWindow(
              data.windowInfo!.windowId.toInt(),
            );
          } else {
            if (data.appInfo != null) {
              get<AppmenuBloc>().add(AppmenuAppExecuted(data.appInfo!));
            }
          }
        },
        decoration: BoxDecoration(
          color: isOpened
              ? context.colorScheme.surface.withValues(
                  alpha: 0.8,
                )
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: isOpened
              ? Border.all(
                  color: context.colorScheme.outlineVariant,
                )
              : null,
          boxShadow: [
            if (isOpened)
              BoxShadow(
                color: context.colorScheme.shadow.withValues(alpha: 0.2),
                blurRadius: 2,
                offset: const Offset(0, 2),
                blurStyle: BlurStyle.outer,
              ),
          ],
        ),
        clipBehavior: Clip.none,
        padding: EdgeInsets.zero,
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
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
                  duration: Durations.medium2,
                  curve: Easing.standard,
                  width: isFocused ? 32 : 8,
                  height: 4,
                  decoration: BoxDecoration(
                    color: data.isPinned
                        ? context.colorScheme.primary
                        : context.colorScheme.secondary,
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
