import 'package:flutter/material.dart';
import 'package:kitshell/etc/buildcontext_extension.dart';

class CalendarAndNotifPopup extends StatelessWidget {
  const CalendarAndNotifPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 520,
      height: 480,
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Placeholder(),
    );
  }
}
