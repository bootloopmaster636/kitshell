// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.2.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:kitshell/src/rust/frb_generated.dart';

Future<WireplumberData> getVolume() =>
    RustLib.instance.api.crateApiWireplumberGetVolume();

Future<void> setVolume({required double volume}) =>
    RustLib.instance.api.crateApiWireplumberSetVolume(volume: volume);

class WireplumberData {

  const WireplumberData({
    required this.volume,
  });
  final double volume;

  @override
  int get hashCode => volume.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WireplumberData &&
          runtimeType == other.runtimeType &&
          volume == other.volume;
}
