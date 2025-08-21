import 'package:flutter/material.dart';

/// Create a icon and text
class TextIcon extends StatelessWidget {
  const TextIcon({
    required this.icon,
    required this.text,
    this.axis = Axis.horizontal,
    this.spacing = 8,
    this.iconFirst = true,
    super.key,
  });

  final Widget icon;
  final Widget text;
  final Axis axis;
  final double spacing;
  final bool iconFirst;

  @override
  Widget build(BuildContext context) {
    return switch (axis) {
      Axis.horizontal => Row(
        mainAxisSize: .min,
        spacing: spacing,
        children: iconFirst
            ? [icon, Flexible(child: text)]
            : [Flexible(child: text), icon],
      ),
      Axis.vertical => Column(
        mainAxisSize: .min,
        spacing: spacing,
        children: iconFirst ? [icon, text] : [text, icon],
      ),
    };
  }
}
