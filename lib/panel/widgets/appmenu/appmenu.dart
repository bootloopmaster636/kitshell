import 'dart:async';
import 'dart:io';

import 'package:contextmenu/contextmenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kitshell/panel/logic/appmenu/appmenu.dart';
import 'package:kitshell/panel/logic/utility_function.dart';
import 'package:kitshell/settings/logic/layer_shell/layer_shell.dart';
import 'package:kitshell/settings/persistence/appmenu_model.dart';
import 'package:kitshell/src/rust/api/appmenu.dart';
import 'package:kitshell/src/rust/api/battery.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

class AppmenuOpenBtn extends ConsumerWidget {
  const AppmenuOpenBtn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        pushExpandedSubmenu(
          context: context,
          ref: ref,
          title: 'My apps',
          child: const AppMenuContent(),
          actions: [
            const PowerButton(),
          ],
        );
      },
      child: const Row(
        children: [
          FaIcon(FontAwesomeIcons.boxesStacked, size: 12),
          Gap(8),
          Text('Apps'),
        ],
      ),
    );
  }
}

class AppMenuContent extends ConsumerWidget {
  const AppMenuContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(appmenuLogicProvider);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: data.isLoading
          ? const Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  Gap(8),
                  Text('Loading apps, this might take a while...'),
                ],
              ),
            )
          : AppmenuList(data: data),
    );
  }
}

class PowerButton extends ConsumerWidget {
  const PowerButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      elevation: 2,
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(999),
      type: MaterialType.button,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTapUp: (detail) {
          showContextMenu(
            detail.globalPosition,
            context,
            (context) => [
              InkWell(
                onTap: () {
                  showToast(
                      ref: ref,
                      context: context,
                      message: 'Hold the button to confirm power off',);
                },
                onLongPress: () {
                  powerControl(selection: PowerState.poweroff);
                },
                child: const ListTile(
                  title: Text('Power off'),
                  leading: Icon(Icons.power_settings_new_outlined),
                ),
              ),
              InkWell(
                onTap: () {
                  showToast(
                      ref: ref,
                      context: context,
                      message: 'Hold the button to confirm reboot',);
                },
                onLongPress: () {
                  powerControl(selection: PowerState.reboot);
                },
                child: const ListTile(
                  title: Text('Reboot'),
                  leading: Icon(Icons.restart_alt_rounded),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  powerControl(selection: PowerState.suspend);
                },
                child: const ListTile(
                  title: Text('Sleep'),
                  leading: Icon(Icons.nights_stay_outlined),
                ),
              ),
            ],
            8.0,
            200.0,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            Icons.power_settings_new_outlined,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class AppmenuList extends HookConsumerWidget {
  const AppmenuList({
    required this.data, super.key,
  });

  final AsyncValue<AppmenuData> data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final panelWidth = ref.watch(layerShellLogicProvider).value!.panelWidth;
    final searchTerm = useState('');
    final filteredFav = useMemoized(
      () => data.value!.appmenuFav
          .where(
            (element) =>
                element.name
                    .toLowerCase()
                    .contains(searchTerm.value.toLowerCase()) ||
                element.description
                    .toLowerCase()
                    .contains(searchTerm.value.toLowerCase()),
          )
          .toList(),
      [searchTerm.value, data.value!.appmenuFav],
    );
    final filteredNonFav = useMemoized(
      () => data.value!.appmenuNoFav
          .where(
            (element) =>
                element.name
                    .toLowerCase()
                    .contains(searchTerm.value.toLowerCase()) ||
                element.description
                    .toLowerCase()
                    .contains(searchTerm.value.toLowerCase()),
          )
          .toList(),
      [searchTerm.value, data.value!.appmenuNoFav],
    );

    return DynMouseScroll(
      durationMS: 200,
      animationCurve: Curves.easeOutQuad,
      builder: (context, controller, physics) => CustomScrollView(
        physics: physics,
        controller: controller,
        slivers: [
          SliverToBoxAdapter(
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: BorderSide.none,
                ),
                fillColor: Theme.of(context).colorScheme.surface,
                filled: true,
                hintText: 'Search for apps...',
                prefixIcon: const Icon(Icons.search),
              ),
              autofocus: true,
              onChanged: (newValue) => searchTerm.value = newValue,
              onSubmitted: (onSubmitted) async {
                final AppmenuInfo app;
                if (data.value!.appmenuFav.isNotEmpty) {
                  app = filteredFav[0];
                } else {
                  app = filteredNonFav[0];
                }

                unawaited(
                    launchApp(exec: app.exec, useTerminal: app.useTerminal),);
                incrementFrequency(app.id);
                await ref
                    .read(layerShellLogicProvider.notifier)
                    .setHeightNormal();
                if (context.mounted) Navigator.pop(context);
              },
            ),
          ),
          const SliverGap(8),
          if (filteredFav.isNotEmpty)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 100,
                child: DynMouseScroll(
                  durationMS: 200,
                  animationCurve: Curves.easeOutQuad,
                  builder: (context, controller, physics) => ListView.builder(
                    controller: controller,
                    physics: physics,
                    scrollDirection: Axis.horizontal,
                    itemCount: filteredFav.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                          width: 160,
                          child: AppmenuFavItem(app: filteredFav[index]),);
                    },
                  ),
                ),
              ),
            ),
          const SliverGap(12),
          const SliverToBoxAdapter(
            child: Text(
              'All apps',
            ),
          ),
          const SliverGap(8),
          SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: panelWidth ~/ 280,
              childAspectRatio: 4,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: filteredNonFav.length,
            itemBuilder: (context, index) {
              return AppmenuNoFavItem(app: filteredNonFav[index]);
            },
          ),
          if (filteredFav.isEmpty && filteredNonFav.isEmpty)
            const SliverToBoxAdapter(
              child: Center(
                child: Text('No apps found'),
              ),
            ),
        ],
      ),
    );
  }
}

class AppmenuFavItem extends ConsumerWidget {
  const AppmenuFavItem({required this.app, super.key});

  final AppmenuInfo app;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ContextMenuArea(
      builder: (BuildContext context) {
        return buildAppInfoContextMenu(context, ref, app);
      },
      child: Card(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        elevation: 2,
        child: InkWell(
          onTap: () async {
            unawaited(launchApp(exec: app.exec, useTerminal: app.useTerminal));
            incrementFrequency(app.id);
            Navigator.pop(context);
            await ref.read(layerShellLogicProvider.notifier).setHeightNormal();
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: AppIcon(path: app.icon),
                ),
                const Gap(8),
                Text(
                  app.name,
                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppmenuNoFavItem extends ConsumerWidget {
  const AppmenuNoFavItem({required this.app, super.key});

  final AppmenuInfo app;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ContextMenuArea(
      builder: (BuildContext context) {
        return buildAppInfoContextMenu(context, ref, app);
      },
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: () async {
            unawaited(launchApp(exec: app.exec, useTerminal: app.useTerminal));
            incrementFrequency(app.id);
            Navigator.pop(context);
            await ref.read(layerShellLogicProvider.notifier).setHeightNormal();
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: AppIcon(path: app.icon),
                ),
                const Gap(8),
                Expanded(
                  child: Text(
                    app.name,
                    style: const TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppIcon extends StatelessWidget {
  const AppIcon({required this.path, super.key});

  final String path;

  @override
  Widget build(BuildContext context) {
    if (path.endsWith('.svg')) {
      return SvgPicture.file(File(path));
    } else if (path.isNotEmpty) {
      return Image.file(File(path));
    } else {
      return const Icon(Icons.apps);
    }
  }
}

List<Widget> buildAppInfoContextMenu(
  BuildContext context,
  WidgetRef ref,
  AppmenuInfo app,
) {
  return [
    Card(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: AppIcon(path: app.icon),
        ),
        title: Text(
          app.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              app.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              app.exec.join(' '),
              style: const TextStyle(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ),
    ListTile(
      title: app.isFavorite
          ? const Text('Remove from favorites')
          : const Text('Add to favorites'),
      onTap: () {
        if (app.isFavorite) {
          changeFavorite(app.id, isFavorite: false);
        } else {
          changeFavorite(app.id, isFavorite: true);
        }

        ref
            .read(appmenuLogicProvider.notifier)
            .refreshList(deleteExisting: false, rescanApps: false);
        Navigator.pop(context);
      },
    ),
  ];
}
