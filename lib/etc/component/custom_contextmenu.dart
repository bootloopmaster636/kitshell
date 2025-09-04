import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

final class CustomContextMenuBuilder extends ContextMenuEntry<Never> {
  const CustomContextMenuBuilder({required this.widget});

  final Widget widget;

  @override
  Widget builder(BuildContext context, ContextMenuState menuState) {
    return widget;
  }
}
