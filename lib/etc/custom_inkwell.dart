import 'package:flutter/material.dart';

/// Custom inkwell component to simplify creating custom button
class CustomInkwell extends StatelessWidget {
  /// Custom inkwell component to simplify creating custom button
  const CustomInkwell({
    required this.child,
    this.decoration,
    this.onTap,
    this.onLongPress,
    this.onTapUp,
    this.onTapDown,
    this.onTapCancel,
    this.onHover,
    this.padding,
    this.height,
    this.width,
    super.key,
  });

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final void Function(TapUpDetails)? onTapUp;
  final void Function(TapDownDetails)? onTapDown;
  final void Function(bool)? onHover;
  final VoidCallback? onTapCancel;
  final BoxDecoration? decoration;
  final EdgeInsets? padding;
  final Widget child;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: decoration?.borderRadius ?? BorderRadius.zero,
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          width: width,
          height: height,
          decoration: decoration,
          child: InkWell(
            onTap: onTap?.call,
            onLongPress: onLongPress?.call,
            onTapUp: onTapUp?.call,
            onTapDown: onTapDown?.call,
            onTapCancel: onTapCancel?.call,
            onHover: onHover?.call,
            child: Padding(
              padding: padding ?? const EdgeInsets.all(8),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
