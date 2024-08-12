import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:kitshell/const.dart';

class Submenu extends StatelessWidget {
  const Submenu({required this.icon, required this.title, required this.body, this.action, super.key});

  final IconData icon;
  final String title;
  final Widget? action;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ColoredBox(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: panelHeight,
                width: panelHeight,
                color: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: panelHeight / 2.5,
                ),
              ),
            )
                .animate(delay: const Duration(milliseconds: 250))
                .fadeIn(
                  begin: 0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCirc,
                )
                .slideX(
                  begin: 0.5,
                  end: 0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCirc,
                ),
            Container(
              width: panelWidth / 4,
              height: panelHeight,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: panelHeight / 3, vertical: panelHeight / 4),
              child: Row(
                children: [
                  FaIcon(
                    icon,
                    size: panelHeight / 2.5,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  const Gap(panelHeight / 6),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: panelHeight / 3,
                    ),
                  ),
                  const Spacer(),
                  action ?? const SizedBox(),
                ],
              ),
            )
                .animate(delay: const Duration(milliseconds: 300))
                .fadeIn(
                  begin: 0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCirc,
                )
                .slideX(
                  begin: 0.5,
                  end: 0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCirc,
                ),
            Expanded(
              child: Container(
                height: panelHeight,
                color: Theme.of(context).colorScheme.surface,
                alignment: Alignment.centerLeft,
                child: body,
              ),
            )
                .animate(delay: const Duration(milliseconds: 350))
                .fadeIn(
                  begin: 0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCirc,
                )
                .slideX(
                  begin: 0.5,
                  end: 0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCirc,
                ),
          ],
        ),
      ),
    );
  }
}

class HoverRevealer extends HookWidget {
  const HoverRevealer({required this.icon, required this.widget, this.value, super.key});

  final IconData icon;
  final Widget widget;
  final int? value;

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: MouseRegion(
        onHover: (event) {
          isHovered.value = true;
        },
        onExit: (event) {
          isHovered.value = false;
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCirc,
              width: isHovered.value ? panelHeight : panelHeight - 16,
              height: panelHeight,
              color: isHovered.value
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondaryContainer,
              alignment: Alignment.center,
              child: Badge(
                label: value == null
                    ? null
                    : Text(
                        value.toString(),
                        style: TextStyle(
                          color: isHovered.value
                              ? Theme.of(context).colorScheme.onSecondaryContainer
                              : Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                backgroundColor: isHovered.value
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSecondaryContainer,
                smallSize: 0,
                largeSize: 10,
                offset: const Offset(4, -8),
                textStyle: const TextStyle(fontSize: 8),
                child: FaIcon(
                  icon,
                  size: panelHeight / 3,
                  color: isHovered.value
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCirc,
              height: panelHeight,
              width: isHovered.value ? panelWidth / 8 : 0,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(0),
              ),
              clipBehavior: Clip.hardEdge,
              alignment: Alignment.centerLeft,
              child: widget,
            ),
          ],
        ),
      ),
    );
  }
}