import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bi.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:kitshell/data/model/runtime/appinfo/appinfo_model.dart';
import 'package:kitshell/etc/component/custom_contextmenu.dart';
import 'package:kitshell/etc/component/custom_inkwell.dart';
import 'package:kitshell/etc/component/text_icon.dart';
import 'package:kitshell/etc/utitity/dart_extension.dart';
import 'package:kitshell/etc/utitity/gap.dart';
import 'package:kitshell/i18n/strings.g.dart';
import 'package:kitshell/injectable.dart';
import 'package:kitshell/logic/panel_components/appmenu/appmenu_bloc.dart';
import 'package:kitshell/logic/panel_components/launchbar/launchbar_bloc.dart';
import 'package:kitshell/logic/screen_manager/screen_manager_bloc.dart';

class AppmenuPopup extends HookWidget {
  const AppmenuPopup({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      get<AppmenuBloc>().add(AppmenuLoad(locale: t.locale));
      return () {};
    }, []);

    return const SizedBox(
      height: 580,
      width: 540,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: AppsList(),
      ),
    );
  }
}

class AppsList extends StatelessWidget {
  const AppsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppmenuBloc, AppmenuState>(
      bloc: get<AppmenuBloc>(),
      builder: (context, state) {
        if (state is! AppmenuLoaded) return const SizedBox.shrink();

        return CustomScrollView(
          slivers: [
            const PinnedHeaderSliver(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: SearchBarComponent(),
              ),
            ),
            Gaps.md.sliverGap,

            // Regular state
            if (state.pinnedEntries.isNotEmpty && state.searchResult == null)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 96,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.pinnedEntries.length,
                    itemBuilder: (context, index) {
                      return AppEntryTilePinned(
                        key: ValueKey(state.pinnedEntries[index].hashCode),
                        appInfo: state.pinnedEntries[index],
                      );
                    },
                  ),
                ),
              ),

            if (state.searchResult == null) Gaps.sm.sliverGap,
            if (state.searchResult == null)
              SliverList.builder(
                itemCount: state.entries.length,
                itemBuilder: (context, index) {
                  return AppEntryTile(
                    key: ValueKey(state.entries[index].hashCode),
                    appInfo: state.entries[index],
                  );
                },
              ),

            // Searching state
            if (state.searchResult != null)
              SliverList.builder(
                itemCount: state.searchResult?.length,
                itemBuilder: (context, index) {
                  return AppEntryTile(
                    key: ValueKey(state.searchResult?[index].hashCode),
                    appInfo: state.searchResult![index],
                  );
                },
              ),
          ],
        );
      },
    );
  }
}

class SearchBarComponent extends HookWidget {
  const SearchBarComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      autoFocus: true,
      onChanged: (val) {
        get<AppmenuBloc>().add(AppmenuSearched(val));
      },
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Iconify(
          Ic.baseline_search,
          color: context.colorScheme.onSurfaceVariant,
        ),
      ),
      hintText: t.appMenu.searchApps,
    );
  }
}

class SearchResultBuilder extends StatelessWidget {
  const SearchResultBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class AppEntryTilePinned extends StatelessWidget {
  const AppEntryTilePinned({required this.appInfo, super.key});

  final AppInfoModel appInfo;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: ContextMenuRegion(
        contextMenu: makeContextMenu(context, appInfo),
        child: CustomInkwell(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          onTap: () {
            get<ScreenManagerBloc>().add(const ScreenManagerEventClosePopup());
            get<AppmenuBloc>().add(
              AppmenuAppExecuted(appInfo),
            );
          },
          child: Column(
            spacing: Gaps.sm.value,
            children: [
              AppIcon(icon: appInfo.metadata.iconPath),
              Text(
                appInfo.entry.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppEntryTile extends StatelessWidget {
  const AppEntryTile({required this.appInfo, super.key});

  final AppInfoModel appInfo;

  @override
  Widget build(BuildContext context) {
    return ContextMenuRegion(
      contextMenu: makeContextMenu(context, appInfo),
      child: CustomInkwell(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        onTap: () {
          get<ScreenManagerBloc>().add(const ScreenManagerEventClosePopup());
          get<AppmenuBloc>().add(
            AppmenuAppExecuted(appInfo),
          );
        },
        child: Row(
          spacing: Gaps.sm.value,
          children: [
            AppIcon(icon: appInfo.metadata.iconPath),
            Text(appInfo.entry.name),
          ],
        ),
      ),
    );
  }
}

class AppIcon extends StatelessWidget {
  const AppIcon({this.icon, this.iconSize = 32, super.key});

  final String? icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final fileExtension = icon?.split('.').last;
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: switch (fileExtension) {
        'png' => Image.file(
          File(icon ?? ''),
          height: iconSize,
          width: iconSize,
          fit: BoxFit.contain,
          cacheHeight: 96,
          cacheWidth: 96,
        ),
        'svg' => SvgPicture.file(
          File(icon ?? ''),
          height: iconSize,
          width: iconSize,
        ),
        null || _ => Container(
          height: iconSize,
          width: iconSize,
          decoration: BoxDecoration(
            color: context.colorScheme.primaryContainer,
            border: Border.all(
              color: context.colorScheme.primary.withValues(alpha: 0.4),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(6),
          child: Iconify(
            Bi.box_seam,
            color: context.colorScheme.onPrimaryContainer,
          ),
        ),
      },
    );
  }
}

ContextMenu<void> makeContextMenu(BuildContext context, AppInfoModel appInfo) {
  final menuEntries = <ContextMenuEntry<void>>[
    CustomContextMenuBuilder(
      widget: Container(
        width: 300,
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          spacing: Gaps.sm.value,
          children: [
            AppIcon(
              icon: appInfo.metadata.iconPath,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appInfo.entry.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (appInfo.entry.desc.isNotEmpty)
                    Text(
                      appInfo.entry.desc,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodySmall,
                    ),
                  Gaps.xs.gap,
                  if (appInfo.entry.exec.isNotEmpty)
                    Text(
                      appInfo.entry.exec.join(' '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelSmall,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    const MenuDivider(color: Colors.transparent),

    CustomContextMenuBuilder(
      widget: CustomInkwell(
        onTap: () {
          get<AppmenuBloc>().add(AppmenuPinToggled(appInfo.entry.id));
          Navigator.of(context).pop();
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: TextIcon(
            text: Text(
              appInfo.metadata.isPinned
                  ? t.appMenu.contextMenu.unpin
                  : t.appMenu.contextMenu.pin,
              style: context.textTheme.bodyMedium,
            ),
            icon: Iconify(
              appInfo.metadata.isPinned
                  ? Ic.outline_pin_off
                  : Ic.outline_push_pin,
              size: 16,
              color: context.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    ),

    CustomContextMenuBuilder(
      widget: CustomInkwell(
        onTap: () {
          get<LaunchbarBloc>().add(LaunchbarEventAdded(appInfo.entry.id));
          Navigator.of(context).pop();
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: TextIcon(
            text: Text(
              t.appMenu.contextMenu.add,
              style: context.textTheme.bodyMedium,
            ),
            icon: Iconify(
              Ic.outline_rocket_launch,
              size: 16,
              color: context.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    ),

    CustomContextMenuBuilder(
      widget: CustomInkwell(
        onTap: () {
          get<AppmenuBloc>().add(AppmenuRankReset(appInfo.entry.id));
          Navigator.of(context).pop();
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: TextIcon(
            text: Text(
              t.appMenu.contextMenu.resetRank,
              style: context.textTheme.bodyMedium,
            ),
            icon: Iconify(
              Ic.outline_restart_alt,
              size: 16,
              color: context.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    ),
  ];

  return ContextMenu(
    entries: menuEntries,
    boxDecoration: BoxDecoration(
      color: context.colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
    ),
    clipBehavior: Clip.antiAlias,
  );
}
