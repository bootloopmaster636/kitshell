import 'package:flutter/material.dart';

enum PopupWidget {
  /// App menu popup
  appMenu(Placeholder()),

  // Calendar and notification popup
  calendar(Placeholder()),

  // Quick setting popup
  quickSettings(Placeholder());

  const PopupWidget(this.widget);
  final Widget widget;
}

enum PanelComponents {
  clockNotif(Placeholder()),
  statusBar(Placeholder()),
  launchBar(Placeholder()),
  appmenuButton(Placeholder()),
  mpris(Placeholder());

  const PanelComponents(this.widget);
  final Widget widget;
}

enum WidgetPosition { left, center, right }
