import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kitshell/const.dart';
import 'package:toastification/toastification.dart';

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
