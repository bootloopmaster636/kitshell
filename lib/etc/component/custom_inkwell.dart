import 'package:flutter/gestures.dart';
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
    this.onPointerEnter,
    this.onPointerExit,
    this.onHover,
    this.padding,
    this.height,
    this.width,
    this.hoverColor,
    this.clipBehavior = Clip.hardEdge,
    super.key,
  });

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final void Function(TapUpDetails)? onTapUp;
  final void Function(TapDownDetails)? onTapDown;
  final VoidCallback? onTapCancel;
  final void Function(PointerHoverEvent)? onHover;
  final void Function(PointerEnterEvent)? onPointerEnter;
  final void Function(PointerExitEvent)? onPointerExit;
  final BoxDecoration? decoration;
  final EdgeInsets? padding;
  final Widget child;
  final double? height;
  final double? width;
  final Color? hoverColor;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: decoration?.borderRadius ?? BorderRadius.zero,
      clipBehavior: clipBehavior,
      child: Container(
        width: width,
        height: height,
        decoration: decoration,
        child: Material(
          color: Colors.transparent,
          clipBehavior: clipBehavior,
          child: MouseRegion(
            onEnter: onPointerEnter?.call,
            onExit: onPointerExit?.call,
            onHover: onHover?.call,
            child: InkWell(
              onTap: onTap?.call,
              onLongPress: onLongPress?.call,
              onTapUp: onTapUp?.call,
              onTapDown: onTapDown?.call,
              onTapCancel: onTapCancel?.call,
              hoverColor: hoverColor,
              child: Padding(
                padding: padding ?? const EdgeInsets.all(8),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
