import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kitshell/etc/component/custom_inkwell.dart';
import 'package:kitshell/etc/component/panel_enum.dart';
import 'package:kitshell/etc/utitity/dart_extension.dart';
import 'package:kitshell/injectable.dart';
import 'package:kitshell/logic/screen_manager/screen_manager_bloc.dart';

/// A container for clickable panel component (e.g. clock and statusbar)
class ClickablePanelComponent extends HookWidget {
  const ClickablePanelComponent({
    required this.content,
    required this.popupToShow,
    required this.popupPosition,
    super.key,
  });
  final Widget content;
  final PopupWidget popupToShow;
  final WidgetPosition popupPosition;

  @override
  Widget build(BuildContext context) {
    final isHovering = useState(false);

    return MouseRegion(
      onEnter: (_) => isHovering.value = true,
      onExit: (_) => isHovering.value = false,
      child: CustomInkwell(
        onTap: () {
          get<ScreenManagerBloc>().add(
            ScreenManagerEventOpenPopup(
              popupToShow: popupToShow,
              position: popupPosition,
            ),
          );
        },
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: isHovering.value
              ? Border.all(color: context.colorScheme.outlineVariant)
              : Border.all(color: Colors.transparent),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: content,
      ),
    );
  }
}
