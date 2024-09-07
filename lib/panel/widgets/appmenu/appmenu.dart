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

class AppmenuOpenBtn extends HookConsumerWidget {
  const AppmenuOpenBtn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchTerm = useState('');
    return ElevatedButton(
      onPressed: () {
        pushExpandedSubmenu(
          context: context,
          ref: ref,
          title: 'Apps',
          child: AppMenuContent(
            searchTerm: searchTerm,
          ),
          actions: [
            SizedBox(
              width: 200,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(999),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Theme.of(context).colorScheme.surface,
                  filled: true,
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                ),
                autofocus: true,
                onChanged: (newValue) => searchTerm.value = newValue,
              ),
            ),
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

class AppMenuContent extends HookConsumerWidget {
  const AppMenuContent({required this.searchTerm, super.key});

  final ValueNotifier<String> searchTerm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(appmenuLogicProvider);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
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
          : AppmenuList(data: data, searchTerm: searchTerm),
    );
  }
}

class AppmenuList extends ConsumerWidget {
  const AppmenuList({
    super.key,
    required this.data,
    required this.searchTerm,
  });

  final AsyncValue<AppmenuData> data;
  final ValueNotifier<String> searchTerm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final panelWidth = ref.watch(layerShellLogicProvider).value!.panelWidth;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(
          child: Text(
            'Favorites',
          ),
        ),
        const SliverGap(8),
        ValueListenableBuilder(
          valueListenable: searchTerm,
          builder: (context, text, widget) => SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: panelWidth / 8,
              mainAxisExtent: panelWidth / 16,
              childAspectRatio: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: data.value!.appmenuFav
                .where((element) => element.name.toLowerCase().contains(searchTerm.value.toLowerCase()))
                .length,
            itemBuilder: (context, index) {
              final app = data.value!.appmenuFav
                  .where((element) => element.name.toLowerCase().contains(searchTerm.value.toLowerCase()))
                  .toList()[index];
              return AppmenuFavItem(app: app);
            },
          ),
        ),
        const SliverGap(12),
        const SliverToBoxAdapter(
          child: Text(
            'All apps',
          ),
        ),
        const SliverGap(8),
        ValueListenableBuilder(
          valueListenable: searchTerm,
          builder: (context, text, widget) => SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: panelWidth ~/ 320,
              childAspectRatio: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: data.value!.appmenuNoFav
                .where((element) => element.name.toLowerCase().contains(text.toLowerCase()))
                .length,
            itemBuilder: (context, index) {
              final app = data.value!.appmenuNoFav
                  .where((element) => element.name.toLowerCase().contains(text.toLowerCase()))
                  .toList()[index];
              return AppmenuNoFavItem(app: app);
            },
          ),
        ),
      ],
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
        return [
          ListTile(
            title: Text('Remove "${app.name}" to favorites'),
            onTap: () {
              changeFavorite(app.id, isFavorite: false);
              ref.read(appmenuLogicProvider.notifier).refreshList(deleteExisting: false, rescanApps: false);
              Navigator.pop(context);
            },
          ),
        ];
      },
      child: Card(
        elevation: 4,
        child: InkWell(
          onTap: () async {
            await launchApp(exec: app.exec);
            incrementFrequency(app.id);
            Navigator.pop(context);
            await ref.read(layerShellLogicProvider.notifier).setHeightNormal();
          },
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
        return [
          ListTile(
            title: Text('Add "${app.name}" to favorites'),
            onTap: () {
              changeFavorite(app.id, isFavorite: true);
              ref.read(appmenuLogicProvider.notifier).refreshList(deleteExisting: false, rescanApps: false);
              Navigator.pop(context);
            },
          ),
        ];
      },
      child: Card(
        elevation: 4,
        child: InkWell(
          onTap: () async {
            await launchApp(exec: app.exec);
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
