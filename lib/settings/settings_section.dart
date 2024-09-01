import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kitshell/panel/logic/settings/look_and_feel.dart';
import 'package:kitshell/settings/enums.dart';

class SectionGeneral extends StatelessWidget {
  const SectionGeneral({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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
                pickerColor: ref.watch(settingsLookAndFeelProvider).value?.color ?? Colors.purple,
                onColorChanged: (color) {
                  ref.read(settingsLookAndFeelProvider.notifier).changeColor(color);
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
                    initialSelection: ref.watch(settingsLookAndFeelProvider).value?.themeMode ?? ThemeModeOption.system,
                    controller: themeModeController,
                    onSelected: (option) {
                      ref.read(settingsLookAndFeelProvider.notifier).changeThemeMode(option);
                    },
                    dropdownMenuEntries: ThemeModeOption.values.map((option) {
                      return DropdownMenuEntry(
                        value: option,
                        label: option.label,
                      );
                    }).toList(growable: false),
                    textStyle: const TextStyle(fontSize: 14),
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
