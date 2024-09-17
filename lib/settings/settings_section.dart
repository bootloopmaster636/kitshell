import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kitshell/panel/logic/appmenu/appmenu.dart';
import 'package:kitshell/panel/logic/utility_function.dart';
import 'package:kitshell/settings/dropdown_value.dart';
import 'package:kitshell/settings/logic/layer_shell/layer_shell.dart';
import 'package:kitshell/settings/logic/look_and_feel/look_and_feel.dart';
import 'package:wayland_layer_shell/types.dart';

class SectionLayerShell extends HookConsumerWidget {
  const SectionLayerShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final panelWidthCtl = useTextEditingController(
        text: ref.watch(layerShellLogicProvider).value?.panelWidth.toString());
    final panelHeightCtl = useTextEditingController(
        text: ref.watch(layerShellLogicProvider).value?.panelHeight.toString());

    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            child: ListTile(
              title: const Text('Panel width'),
              visualDensity: VisualDensity.standard,
              trailing: SizedBox(
                width: 100,
                child: TextField(
                  controller: panelWidthCtl,
                  decoration: const InputDecoration(
                    isDense: true,
                    suffix: Text('px'),
                  ),
                  textAlign: TextAlign.end,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    ref
                        .read(layerShellLogicProvider.notifier)
                        .setPanelWidth(int.tryParse(value) ?? 1366);
                  },
                ),
              ),
            ),
          ),
          const Gap(4),
          Card(
            child: ListTile(
              title: const Text('Panel height'),
              subtitle:
                  const Text('⚠️ Experimental, might not work as expected'),
              visualDensity: VisualDensity.standard,
              trailing: SizedBox(
                width: 100,
                child: TextField(
                  controller: panelHeightCtl,
                  decoration: const InputDecoration(
                    isDense: true,
                    suffix: Text('px'),
                  ),
                  textAlign: TextAlign.end,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    ref
                        .read(layerShellLogicProvider.notifier)
                        .setPanelHeight(int.tryParse(value) ?? 48);
                  },
                ),
              ),
            ),
          ),
          const Gap(4),
          Card(
            child: ListTile(
              title: const Text('Auto exclusive zone'),
              subtitle: const Text(
                  'If disabled, the window will not be pushed when expanded menu shows up.'),
              visualDensity: VisualDensity.standard,
              trailing: Switch(
                value: ref
                        .watch(layerShellLogicProvider)
                        .value
                        ?.autoExclusiveZone ??
                    true,
                onChanged: (value) {
                  ref
                      .read(layerShellLogicProvider.notifier)
                      .setAutoExclusiveZone(value);
                },
              ),
            ),
          ),
          const Gap(4),
          Card(
            child: ListTile(
              title: const Text('Shell layer'),
              subtitle: const Text(
                  'Select the layer where the panel should be placed'),
              visualDensity: VisualDensity.standard,
              trailing: DropdownMenu<ShellLayerOption>(
                initialSelection: ShellLayerOption.layerTop,
                onSelected: (option) {
                  ref
                      .read(layerShellLogicProvider.notifier)
                      .setLayer(option?.value ?? ShellLayer.layerTop);
                },
                dropdownMenuEntries: ShellLayerOption.values.map((option) {
                  return DropdownMenuEntry(
                    value: option,
                    label: option.label,
                  );
                }).toList(growable: false),
                textStyle: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          const Gap(8),
          FilledButton(
            onPressed: () async {
              await ref
                  .read(layerShellLogicProvider.notifier)
                  .applySettings()
                  .then((val) {
                ref.read(layerShellLogicProvider.notifier).setHeightExpanded();
              });
            },
            child: const Text('Apply layer shell settings'),
          ),
        ],
      ),
    );
  }
}

class SectionLookAndFeel extends HookConsumerWidget {
  const SectionLookAndFeel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeController = useTextEditingController();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: ExpandablePanel(
              theme: ExpandableThemeData(
                hasIcon: true,
                iconColor: Theme.of(context).colorScheme.onSurface,
                headerAlignment: ExpandablePanelHeaderAlignment.center,
              ),
              header: const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text('Accent Color'),
              ),
              expanded: MaterialPicker(
                pickerColor:
                    ref.watch(settingsLookAndFeelProvider).value?.color ??
                        Colors.purple,
                onColorChanged: (color) {
                  ref
                      .read(settingsLookAndFeelProvider.notifier)
                      .changeColor(color);
                },
              ),
              collapsed: const SizedBox(),
            ),
          ),
          const Gap(8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text('Theme mode'),
                  const Spacer(),
                  DropdownMenu<ThemeModeOption>(
                    initialSelection: ref
                            .watch(settingsLookAndFeelProvider)
                            .value
                            ?.themeMode ??
                        ThemeModeOption.system,
                    controller: themeModeController,
                    onSelected: (option) {
                      ref
                          .read(settingsLookAndFeelProvider.notifier)
                          .changeThemeMode(option);
                    },
                    dropdownMenuEntries: ThemeModeOption.values.map((option) {
                      return DropdownMenuEntry(
                        value: option,
                        label: option.label,
                      );
                    }).toList(growable: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionAppmenu extends HookConsumerWidget {
  const SectionAppmenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appData = ref.watch(appmenuLogicProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            child: ListTile(
              title: const Text('Refresh list'),
              subtitle: const Text(
                'Got new apps? You can rescan it to add to the list.',
              ),
              trailing: FilledButton(
                onPressed: () {
                  ref
                      .read(appmenuLogicProvider.notifier)
                      .refreshList(deleteExisting: false, rescanApps: true);
                },
                child: const Text('Refresh'),
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Reset list'),
              subtitle: const Text(
                'Something bad happened or gone wrong? Reset the app list '
                'to rebuild the app database. THIS WILL REMOVE YOUR FAVORITES '
                'AND FREQUENCY DATA.',
              ),
              trailing: FilledButton(
                onPressed: () {
                  showToast(
                    ref: ref,
                    context: context,
                    message: 'Long press '
                        'the button to confirm reset',
                  );
                },
                onLongPress: () {
                  ref
                      .read(appmenuLogicProvider.notifier)
                      .refreshList(deleteExisting: true, rescanApps: true);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                child: const Text('Reset'),
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Status'),
              subtitle: appData.isLoading
                  ? const Text('Loading...')
                  : Text(
                      'You have ${appData.value?.appmenuFav.length.toString()} favorited apps and '
                      '${appData.value?.appmenuNoFav.length.toString()} non favorited apps'),
            ),
          )
        ],
      ),
    );
  }
}
