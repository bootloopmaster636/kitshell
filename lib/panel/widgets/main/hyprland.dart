import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kitshell/panel/logic/hyprland/hyprland.dart';
import 'package:kitshell/settings/logic/layer_shell/layer_shell.dart';
import 'package:kitshell/src/rust/api/hyprland.dart';

class Hyprland extends HookConsumerWidget {
  const Hyprland({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeWindowTitle = ref.watch(hyprlandLogicProvider).value?.activeWindowTitle;
    final isHovered = useState(false);
    final panelWidth = ref.watch(layerShellLogicProvider).value!.panelWidth.toDouble();
    final panelHeight = ref.watch(layerShellLogicProvider).value!.panelHeight.toDouble();

    return MouseRegion(
      onHover: (_) => isHovered.value = true,
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: AnimatedContainer(
        duration: 400.ms,
        curve: Curves.easeOutExpo,
        width: isHovered.value ? panelWidth / 3 : panelWidth / 4,
        height: panelHeight,
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
            Flexible(
              flex: 3,
              child: WorkspaceSwitcher(
                isHovered: isHovered,
              ),
            ),
            Flexible(
              flex: 5,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    activeWindowTitle ?? 'Unknown',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
            AnimatedCrossFade(
              duration: 400.ms,
              sizeCurve: Curves.easeOutExpo,
              crossFadeState: isHovered.value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              firstChild: IconButton(
                onPressed: dispatchKillActive,
                icon: FaIcon(
                  FontAwesomeIcons.circleXmark,
                  size: panelHeight / 3,
                ),
              ),
              secondChild: const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkspaceSwitcher extends ConsumerWidget {
  const WorkspaceSwitcher({required this.isHovered, super.key});

  final ValueNotifier<bool> isHovered;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeWorkspace = ref.watch(hyprlandLogicProvider).value?.activeWorkspace;
    final panelHeight = ref.watch(layerShellLogicProvider).value!.panelHeight.toDouble();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedCrossFade(
            duration: 400.ms,
            sizeCurve: Curves.easeOutExpo,
            crossFadeState: isHovered.value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: IconButton(
              onPressed: dispatchSwitchWorkspacePrevious,
              visualDensity: VisualDensity.compact,
              icon: FaIcon(
                FontAwesomeIcons.angleLeft,
                size: panelHeight / 3,
              ),
            ),
            secondChild: const SizedBox(),
          ),
          Text(
            'Desktop ${activeWorkspace?.id.toString()}',
            overflow: TextOverflow.ellipsis,
          ),
          AnimatedCrossFade(
            duration: 400.ms,
            sizeCurve: Curves.easeOutExpo,
            crossFadeState: isHovered.value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: IconButton(
              onPressed: dispatchSwitchWorkspaceNext,
              visualDensity: VisualDensity.compact,
              icon: FaIcon(
                FontAwesomeIcons.angleRight,
                size: panelHeight / 3,
              ),
            ),
            secondChild: const SizedBox(),
          ),
        ],
      ),
    );
  }
}
