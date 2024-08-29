// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.2.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

Future<BrightnessData> getBrightness() =>
    RustLib.instance.api.crateApiBrightnessGetBrightness();

Future<void> setBrightnessAll({required int brightness}) => RustLib.instance.api
    .crateApiBrightnessSetBrightnessAll(brightness: brightness);

class BrightnessData {
  final List<String> deviceName;
  final Uint32List brightness;

  const BrightnessData({
    required this.deviceName,
    required this.brightness,
  });

  @override
  int get hashCode => deviceName.hashCode ^ brightness.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrightnessData &&
          runtimeType == other.runtimeType &&
          deviceName == other.deviceName &&
          brightness == other.brightness;
}
