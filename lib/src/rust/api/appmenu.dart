// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.3.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

Future<List<AppData>> getAllApps() =>
    RustLib.instance.api.crateApiAppmenuGetAllApps();

Future<String> findIconPathFromIconName({required String iconName}) =>
    RustLib.instance.api
        .crateApiAppmenuFindIconPathFromIconName(iconName: iconName);

Future<void> launchApp(
        {required List<String> exec, required bool useTerminal}) =>
    RustLib.instance.api
        .crateApiAppmenuLaunchApp(exec: exec, useTerminal: useTerminal);

class AppData {
  final String name;
  final List<String> exec;
  final String icon;
  final bool useTerminal;

  const AppData({
    required this.name,
    required this.exec,
    required this.icon,
    required this.useTerminal,
  });

  @override
  int get hashCode =>
      name.hashCode ^ exec.hashCode ^ icon.hashCode ^ useTerminal.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppData &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          exec == other.exec &&
          icon == other.icon &&
          useTerminal == other.useTerminal;
}
