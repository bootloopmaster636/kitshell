import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:kitshell/panel/logic/settings/look_and_feel.dart';

final List<Widget> settingsSectionContents = [
  const SectionGeneral(),
  const SectionLookAndFeel(),
];

class SettingsContent extends HookWidget {
  const SettingsContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedSection = useState(0);

    return Row(
      children: [
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: SettingsSectionContent(
              notifier: selectedSection,
            ),
          ),
        ),
        const Gap(8),
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(16),
            child: settingsSectionContents[selectedSection.value],
          ),
        ),
      ],
    );
  }
}

class SettingsSectionContent extends StatelessWidget {
  const SettingsSectionContent({required this.notifier, super.key});

  final ValueNotifier<int> notifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingsSectionTile(
          index: 0,
          title: 'General',
          icon: Icons.settings_outlined,
          notifier: notifier,
        ),
        SettingsSectionTile(
          index: 1,
          title: 'Look and feel',
          icon: Icons.format_paint_outlined,
          notifier: notifier,
        ),
      ],
    );
  }
}

class SectionGeneral extends StatelessWidget {
  const SectionGeneral({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class SectionLookAndFeel extends ConsumerWidget {
  const SectionLookAndFeel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          Placeholder(),
        ],
      ),
    );
  }
}

class SettingsSectionTile extends StatelessWidget {
  const SettingsSectionTile({
    required this.index,
    required this.title,
    required this.icon,
    required this.notifier,
    super.key,
  });

  final ValueNotifier<int> notifier;
  final int index;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: notifier.value == index
          ? Theme.of(context).colorScheme.surfaceContainerHigh
          : Theme.of(context).colorScheme.surface,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: () {
          notifier.value = index;
        },
      ),
    );
  }
}
