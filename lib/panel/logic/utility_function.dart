import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kitshell/const.dart';
import 'package:kitshell/panel/widgets/utility_widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:toastification/toastification.dart';
import 'package:wayland_layer_shell/wayland_layer_shell.dart';

void showToast({
  required BuildContext context,
  required String message,
  IconData? icon,
  // ImageProvider? image,
}) {
  toastification.showCustom(
    autoCloseDuration: toastDuration,
    alignment: Alignment.centerRight,
    animationDuration: const Duration(milliseconds: 800),
    animationBuilder: (context, animation, alignment, child) {
      return SlideTransition(
        position: animation.drive(
          Tween(begin: const Offset(0, 1), end: Offset.zero).chain(
            CurveTween(curve: Curves.easeOutExpo),
          ),
        ),
        child: child,
      );
    },
    builder: (BuildContext context, ToastificationItem holder) {
      return Container(
        height: panelHeight,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            if (icon != null) Icon(icon),
            if (icon != null) const Gap(8),
            Text(message),
          ],
        ),
      );
    },
  );
}

void pushExpandedSubmenu({required BuildContext context, required String title, required Widget child}) {
  WaylandLayerShell().initialize(panelWidth.toInt(), expandedPanelHeight.toInt());
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.bottomToTop,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 120),
      curve: Curves.easeOutExpo,
      child: ExpandedSubmenu(
        title: title,
        child: child,
      ),
    ),
  );
}
