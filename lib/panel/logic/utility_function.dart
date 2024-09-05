import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:kitshell/const.dart';
import 'package:kitshell/panel/widgets/utility_widgets.dart';
import 'package:kitshell/settings/logic/layer_shell/layer_shell.dart';
import 'package:page_transition/page_transition.dart';
import 'package:toastification/toastification.dart';

void showToast({
  required WidgetRef ref,
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
        height: ref.watch(layerShellLogicProvider).value!.panelHeight.toDouble(),
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

void pushExpandedSubmenu(
    {required BuildContext context,
    required WidgetRef ref,
    required String title,
    required Widget child,
    List<Widget>? actions}) {
  ref.read(layerShellLogicProvider.notifier).setHeightExpanded();
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.bottomToTop,
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 250),
      curve: Curves.easeOutExpo,
      child: ExpandedSubmenu(
        title: title,
        actions: actions,
        child: child,
      ),
    ),
  );
}
