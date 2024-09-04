import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:kitshell/const.dart';
import 'package:kitshell/panel/logic/hyprland/hyprland.dart';
import 'package:kitshell/src/rust/api/hyprland.dart';

class Hyprland extends ConsumerWidget {
  const Hyprland({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeWindowTitle = ref.watch(hyprlandLogicProvider).value?.activeWindowTitle;

    return Container(
      width: panelWidth / 3,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.4),
            blurRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Flexible(
            flex: 2,
            child: WorkspaceSwitcher(),
          ),
          const Gap(8),
          Flexible(
            flex: 4,
            child: Center(
              child: Text(activeWindowTitle ?? 'Unknown'),
            ),
          ),
        ],
      ),
    ).animate(delay: 400.ms).scaleX(
          begin: 0,
          end: 1,
          duration: 800.ms,
          curve: Curves.easeOutExpo,
        );
  }
}

class WorkspaceSwitcher extends ConsumerWidget {
  const WorkspaceSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeWorkspace = ref.watch(hyprlandLogicProvider).value?.activeWorkspace;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: dispatchSwitchWorkspacePrevious,
            visualDensity: VisualDensity.compact,
            icon: const FaIcon(
              FontAwesomeIcons.angleLeft,
              size: panelHeight / 3,
            ),
          ),
          Text(
            'Desktop ${activeWorkspace?.id.toString()}',
            overflow: TextOverflow.ellipsis,
          ),
          IconButton(
            onPressed: dispatchSwitchWorkspaceNext,
            visualDensity: VisualDensity.compact,
            icon: const FaIcon(
              FontAwesomeIcons.angleRight,
              size: panelHeight / 3,
            ),
          ),
        ],
      ),
    );
  }
}
