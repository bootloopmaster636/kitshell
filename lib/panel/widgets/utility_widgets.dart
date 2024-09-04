import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitshell/const.dart';
import 'package:wayland_layer_shell/wayland_layer_shell.dart';

class Submenu extends HookWidget {
  const Submenu({
    required this.title,
    required this.body,
    this.icon,
    this.action,
    super.key,
  });

  final IconData? icon;
  final String title;
  final Widget? action;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final isExitHovered = useState(false);

    return Material(
      child: ColoredBox(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: Row(
          children: [
            MouseRegion(
              onHover: (event) {
                isExitHovered.value = true;
              },
              onExit: (event) {
                isExitHovered.value = false;
              },
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: panelHeight,
                  width: panelHeight,
                  color: Theme.of(context).colorScheme.secondary,
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Theme.of(context).colorScheme.onSecondary,
                    size: panelHeight / 2,
                  )
                      .animate(
                        target: isExitHovered.value ? 1 : 0,
                      )
                      .slideY(
                        begin: 0,
                        end: 0.2,
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeInOutSine,
                      ),
                ),
              )
                  .animate(delay: const Duration(milliseconds: 250))
                  .fadeIn(
                    begin: 0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCirc,
                  )
                  .slideY(
                    begin: 0.8,
                    end: 0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCirc,
                  ),
            ),
            Container(
              width: panelWidth / 4,
              height: panelHeight,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(
                horizontal: panelHeight / 3,
              ),
              child: Row(
                children: [
                  if (icon != null)
                    FaIcon(
                      icon,
                      size: panelHeight / 3,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  if (icon != null) const Gap(8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: panelHeight / 3,
                    ),
                  ),
                  const Spacer(),
                  if (action != null) action!,
                ],
              ),
            )
                .animate(delay: const Duration(milliseconds: 300))
                .fadeIn(
                  begin: 0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCirc,
                )
                .slideY(
                  begin: 0.8,
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
                .slideY(
                  begin: 0.8,
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
  const HoverRevealer({
    required this.icon,
    required this.widget,
    this.iconSize,
    this.iconOverlay,
    this.value,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final double? iconSize;
  final IconData? iconOverlay;
  final Widget widget;
  final int? value;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: MouseRegion(
        onHover: (event) {
          isHovered.value = true;
        },
        onExit: (event) {
          isHovered.value = false;
        },
        child: GestureDetector(
          onTap: onTap == null
              ? null
              : () {
                  onTap!();
                },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCirc,
                width: isHovered.value ? panelHeight : panelHeight - 16,
                height: panelHeight,
                decoration: BoxDecoration(
                  color: isHovered.value ? Theme.of(context).colorScheme.surface : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(999),
                    bottomLeft: Radius.circular(999),
                  ),
                  boxShadow: [
                    if (isHovered.value)
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 1,
                      ),
                  ],
                ),
                alignment: Alignment.center,
                child: Badge(
                  label: value == null
                      ? null
                      : Text(
                          value.toString(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  smallSize: 0,
                  largeSize: 10,
                  textStyle: const TextStyle(fontSize: 6, fontWeight: FontWeight.bold),
                  offset: const Offset(6, -6),
                  child: iconOverlay == null
                      ? FaIcon(
                          icon,
                          size: iconSize ?? panelHeight / 3,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        )
                      : Stack(
                          clipBehavior: Clip.none,
                          children: [
                            FaIcon(
                              icon,
                              size: iconSize ?? panelHeight / 3,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                            Positioned(
                              bottom: 0,
                              right: -6,
                              child: FaIcon(
                                iconOverlay,
                                size: panelHeight / 6,
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              Visibility(
                visible: isHovered.value,
                child: Container(
                  height: panelHeight,
                  width: panelWidth / 8,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(999),
                      bottomRight: Radius.circular(999),
                    ),
                    boxShadow: [
                      if (isHovered.value)
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 1,
                        ),
                    ],
                  ),
                  clipBehavior: Clip.hardEdge,
                  alignment: Alignment.centerLeft,
                  child: widget,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({this.customLoadingMessage, super.key});

  final String? customLoadingMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          const SizedBox(
            height: panelHeight / 2,
            width: panelHeight / 2,
            child: CircularProgressIndicator(),
          ),
          const Gap(16),
          Text(
            customLoadingMessage ?? 'Loading',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: panelHeight / 3,
            ),
          ),
        ],
      ),
    );
  }
}

class ExpandedSubmenu extends StatelessWidget {
  const ExpandedSubmenu({required this.title, required this.child, super.key});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: expandedPanelHeight,
        width: panelWidth,
        color: Theme.of(context).colorScheme.primaryContainer,
        padding: const EdgeInsets.symmetric(horizontal: panelWidth / 6, vertical: 8),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    WaylandLayerShell().initialize(panelWidth.toInt(), panelHeight.toInt());
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.keyboard_arrow_down_rounded),
                ),
                const Gap(4),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            )
                .animate(delay: 300.ms)
                .fadeIn(
                  duration: 800.ms,
                  curve: Curves.easeOutExpo,
                )
                .slideY(
                  begin: 0.4,
                  end: 0,
                  duration: 800.ms,
                  curve: Curves.easeOutExpo,
                ),
            const Gap(4),
            Expanded(
              child: child
                  .animate(
                    delay: 350.ms,
                  )
                  .fadeIn(
                    duration: 800.ms,
                    curve: Curves.easeOutExpo,
                  )
                  .slideY(
                    begin: 0.2,
                    end: 0,
                    duration: 800.ms,
                    curve: Curves.easeOutExpo,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/logoV1.svg',
              width: panelHeight - 8,
            ),
            const Gap(4),
            Text(
              'Kitshell',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontFamily: GoogleFonts.inter().fontFamily,
              ),
            ),
            const Gap(64),
            const SizedBox(
              width: panelWidth / 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Initializing...'),
                  const Gap(4),
                  LinearProgressIndicator(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
