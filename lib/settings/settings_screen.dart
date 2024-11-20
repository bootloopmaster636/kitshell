import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:kitshell/main.dart';
import 'package:kitshell/panel/logic/utility_function.dart';
import 'package:kitshell/settings/settings_section.dart';
import 'package:url_launcher/url_launcher.dart';

final List<Widget> settingsSectionContents = [
  const SectionLookAndFeel(),
  const SectionLayerShell(),
  const SectionAppmenu(),
];

class SettingsContent extends HookWidget {
  const SettingsContent({super.key});

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
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                ),
              ],
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
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                ),
              ],
            ),
            height: double.infinity,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SettingsSectionTile(
                  index: 0,
                  title: 'Look and feel',
                  icon: Icons.format_paint_outlined,
                  notifier: notifier,
                ),
                SettingsSectionTile(
                  index: 1,
                  title: 'Layer shell',
                  icon: Icons.layers_outlined,
                  notifier: notifier,
                ),
                SettingsSectionTile(
                  index: 2,
                  title: 'App menu',
                  icon: Icons.apps_rounded,
                  notifier: notifier,
                ),
              ],
            ),
          ),
        ),
        const GithubButton(),
      ],
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
        leading: Icon(
          icon,
          size: 20,
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
        onTap: () {
          notifier.value = index;
        },
      ),
    );
  }
}

class GithubButton extends ConsumerWidget {
  const GithubButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
        onPressed: () {
          final kitshellRepo =
              Uri.parse('https://github.com/bootloopmaster636/kitshell');
          try {
            launchUrl(kitshellRepo);
          } catch (e) {
            showToast(
                ref: ref,
                context: context,
                message: 'Failed to open Kitshell repo',);
          }
        },
        child: Row(
          children: [
            const FaIcon(
              FontAwesomeIcons.github,
              size: 16,
            ),
            const Gap(8),
            Text("You're running Kitshell v$version"),
          ],
        ),);
  }
}
