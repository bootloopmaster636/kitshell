import 'package:flutter/material.dart';
import 'package:kitshell/screen/popup/components/calendar_and_notif.dart';
import 'package:kitshell/screen/popup/components/quick_settings/quick_settings.dart';

enum PopupWidget {
  /// App menu popup
  appMenu(Placeholder()),

  // Calendar and notification popup
  calendar(CalendarAndNotifPopup()),

  // Quick setting popup
  quickSettings(QuickSettingsPopup());

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
