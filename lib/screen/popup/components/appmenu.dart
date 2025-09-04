import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bi.dart';
import 'package:kitshell/data/model/runtime/appinfo/appinfo_model.dart';
import 'package:kitshell/etc/component/custom_inkwell.dart';
import 'package:kitshell/etc/utitity/config.dart';
import 'package:kitshell/etc/utitity/dart_extension.dart';
import 'package:kitshell/etc/utitity/gap.dart';
import 'package:kitshell/injectable.dart';
import 'package:kitshell/logic/panel_components/appmenu/appmenu_bloc.dart';
import 'package:kitshell/src/rust/api/appmenu/appmenu_items.dart';

class AppmenuPopup extends StatelessWidget {
  const AppmenuPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 580,
      width: 540,
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer.withValues(
          alpha: popupBgOpacity,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(16),
      child: const AppsList(),
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
            SliverList.builder(
              itemCount: state.entries.length,
              itemBuilder: (context, index) {
                return AppEntryTile(appInfo: state.entries[index]);
              },
            ),
          ],
        );
      },
    );
  }
}

class AppEntryTilePinned extends StatelessWidget {
  const AppEntryTilePinned({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class AppEntryTile extends StatelessWidget {
  const AppEntryTile({required this.appInfo, super.key});

  final AppInfoModel appInfo;

  @override
  Widget build(BuildContext context) {
    return CustomInkwell(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      onTap: () {},
      child: Row(
        spacing: Gaps.sm.value,
        children: [
          AppIcon(icon: appInfo.metadata.iconPath),
          Text(appInfo.entry.name),
        ],
      ),
    );
  }
}

class AppIcon extends StatelessWidget {
  const AppIcon({this.icon, super.key});

  final String? icon;

  @override
  Widget build(BuildContext context) {
    const double iconSize = 32;

    final fileExtension = icon?.split('.').last;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: switch (fileExtension) {
        'png' => Image.file(
          File(icon ?? ''),
          height: iconSize,
          width: iconSize,
          fit: BoxFit.fill,
        ),
        'svg' => SvgPicture.file(
          File(icon ?? ''),
          height: iconSize,
          width: iconSize,
          fit: BoxFit.fill,
        ),
        null || _ => Container(
          height: iconSize,
          width: iconSize,
          color: context.colorScheme.primaryContainer,
          padding: const EdgeInsets.all(8),
          child: Iconify(
            Bi.box_seam,
            color: context.colorScheme.onPrimaryContainer,
          ),
        ),
      },
    );
  }
}
