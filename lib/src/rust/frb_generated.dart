// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.2.0.

// ignore_for_file: unused_import, unused_element, unnecessary_import, duplicate_ignore, invalid_use_of_internal_member, annotate_overrides, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, unused_field

import 'api/battery.dart';
import 'api/brightness.dart';
import 'api/init.dart';
import 'api/mpris.dart';
import 'api/wifi.dart';
import 'api/wireplumber.dart';
import 'dart:async';
import 'dart:convert';
import 'frb_generated.dart';
import 'frb_generated.io.dart'
    if (dart.library.js_interop) 'frb_generated.web.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

/// Main entrypoint of the Rust API
class RustLib extends BaseEntrypoint<RustLibApi, RustLibApiImpl, RustLibWire> {
  @internal
  static final instance = RustLib._();

  RustLib._();

  /// Initialize flutter_rust_bridge
  static Future<void> init({
    RustLibApi? api,
    BaseHandler? handler,
    ExternalLibrary? externalLibrary,
  }) async {
    await instance.initImpl(
      api: api,
      handler: handler,
      externalLibrary: externalLibrary,
    );
  }

  /// Dispose flutter_rust_bridge
  ///
  /// The call to this function is optional, since flutter_rust_bridge (and everything else)
  /// is automatically disposed when the app stops.
  static void dispose() => instance.disposeImpl();

  @override
  ApiImplConstructor<RustLibApiImpl, RustLibWire> get apiImplConstructor =>
      RustLibApiImpl.new;

  @override
  WireConstructor<RustLibWire> get wireConstructor =>
      RustLibWire.fromExternalLibrary;

  @override
  Future<void> executeRustInitializers() async {}

  @override
  ExternalLibraryLoaderConfig get defaultExternalLibraryLoaderConfig =>
      kDefaultExternalLibraryLoaderConfig;

  @override
  String get codegenVersion => '2.2.0';

  @override
  int get rustContentHash => -333969806;

  static const kDefaultExternalLibraryLoaderConfig =
      ExternalLibraryLoaderConfig(
    stem: 'rust_lib_kitshell',
    ioDirectory: 'rust/target/release/',
    webPrefix: 'pkg/',
  );
}

abstract class RustLibApi extends BaseApi {
  Future<BatteryData> crateApiBatteryGetBatteryData();

  Future<PowerProfiles> crateApiBatteryGetPowerProfile();

  Future<void> crateApiBatterySetPowerProfile({required PowerProfiles profile});

  Future<BrightnessData> crateApiBrightnessGetBrightness();

  Future<void> crateApiBrightnessSetBrightnessAll({required int brightness});

  Future<void> crateApiInitEnableRustStacktrace();

  Future<MprisData> crateApiMprisGetMprisData();

  Future<void> crateApiMprisPlayerNext();

  Future<void> crateApiMprisPlayerPause();

  Future<void> crateApiMprisPlayerPlay();

  Future<void> crateApiMprisPlayerPrevious();

  Future<bool> crateApiWifiConnectToWifi(
      {required String ssid, required String password});

  Future<List<WifiData>> crateApiWifiGetWifiList({required bool rescan});

  Future<WireplumberData> crateApiWireplumberGetVolume();

  Future<void> crateApiWireplumberSetVolume({required double volume});
}

class RustLibApiImpl extends RustLibApiImplPlatform implements RustLibApi {
  RustLibApiImpl({
    required super.handler,
    required super.wire,
    required super.generalizedFrbRustBinding,
    required super.portManager,
  });

  @override
  Future<BatteryData> crateApiBatteryGetBatteryData() {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 1, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_battery_data,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiBatteryGetBatteryDataConstMeta,
      argValues: [],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiBatteryGetBatteryDataConstMeta =>
      const TaskConstMeta(
        debugName: "get_battery_data",
        argNames: [],
      );

  @override
  Future<PowerProfiles> crateApiBatteryGetPowerProfile() {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 2, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_power_profiles,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiBatteryGetPowerProfileConstMeta,
      argValues: [],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiBatteryGetPowerProfileConstMeta =>
      const TaskConstMeta(
        debugName: "get_power_profile",
        argNames: [],
      );

  @override
  Future<void> crateApiBatterySetPowerProfile(
      {required PowerProfiles profile}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_power_profiles(profile, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 3, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiBatterySetPowerProfileConstMeta,
      argValues: [profile],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiBatterySetPowerProfileConstMeta =>
      const TaskConstMeta(
        debugName: "set_power_profile",
        argNames: ["profile"],
      );

  @override
  Future<BrightnessData> crateApiBrightnessGetBrightness() {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 4, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_brightness_data,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiBrightnessGetBrightnessConstMeta,
      argValues: [],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiBrightnessGetBrightnessConstMeta =>
      const TaskConstMeta(
        debugName: "get_brightness",
        argNames: [],
      );

  @override
  Future<void> crateApiBrightnessSetBrightnessAll({required int brightness}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_u_32(brightness, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 5, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiBrightnessSetBrightnessAllConstMeta,
      argValues: [brightness],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiBrightnessSetBrightnessAllConstMeta =>
      const TaskConstMeta(
        debugName: "set_brightness_all",
        argNames: ["brightness"],
      );

  @override
  Future<void> crateApiInitEnableRustStacktrace() {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 6, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiInitEnableRustStacktraceConstMeta,
      argValues: [],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiInitEnableRustStacktraceConstMeta =>
      const TaskConstMeta(
        debugName: "enable_rust_stacktrace",
        argNames: [],
      );

  @override
  Future<MprisData> crateApiMprisGetMprisData() {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 7, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_mpris_data,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kCrateApiMprisGetMprisDataConstMeta,
      argValues: [],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiMprisGetMprisDataConstMeta => const TaskConstMeta(
        debugName: "get_mpris_data",
        argNames: [],
      );

  @override
  Future<void> crateApiMprisPlayerNext() {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 8, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiMprisPlayerNextConstMeta,
      argValues: [],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiMprisPlayerNextConstMeta => const TaskConstMeta(
        debugName: "player_next",
        argNames: [],
      );

  @override
  Future<void> crateApiMprisPlayerPause() {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 9, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiMprisPlayerPauseConstMeta,
      argValues: [],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiMprisPlayerPauseConstMeta => const TaskConstMeta(
        debugName: "player_pause",
        argNames: [],
      );

  @override
  Future<void> crateApiMprisPlayerPlay() {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 10, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiMprisPlayerPlayConstMeta,
      argValues: [],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiMprisPlayerPlayConstMeta => const TaskConstMeta(
        debugName: "player_play",
        argNames: [],
      );

  @override
  Future<void> crateApiMprisPlayerPrevious() {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 11, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiMprisPlayerPreviousConstMeta,
      argValues: [],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiMprisPlayerPreviousConstMeta =>
      const TaskConstMeta(
        debugName: "player_previous",
        argNames: [],
      );

  @override
  Future<bool> crateApiWifiConnectToWifi(
      {required String ssid, required String password}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_String(ssid, serializer);
        sse_encode_String(password, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 12, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_bool,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kCrateApiWifiConnectToWifiConstMeta,
      argValues: [ssid, password],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiWifiConnectToWifiConstMeta => const TaskConstMeta(
        debugName: "connect_to_wifi",
        argNames: ["ssid", "password"],
      );

  @override
  Future<List<WifiData>> crateApiWifiGetWifiList({required bool rescan}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_bool(rescan, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 13, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_list_wifi_data,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiWifiGetWifiListConstMeta,
      argValues: [rescan],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiWifiGetWifiListConstMeta => const TaskConstMeta(
        debugName: "get_wifi_list",
        argNames: ["rescan"],
      );

  @override
  Future<WireplumberData> crateApiWireplumberGetVolume() {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 14, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_wireplumber_data,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiWireplumberGetVolumeConstMeta,
      argValues: [],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiWireplumberGetVolumeConstMeta =>
      const TaskConstMeta(
        debugName: "get_volume",
        argNames: [],
      );

  @override
  Future<void> crateApiWireplumberSetVolume({required double volume}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_f_32(volume, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 15, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiWireplumberSetVolumeConstMeta,
      argValues: [volume],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiWireplumberSetVolumeConstMeta =>
      const TaskConstMeta(
        debugName: "set_volume",
        argNames: ["volume"],
      );

  @protected
  AnyhowException dco_decode_AnyhowException(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return AnyhowException(raw as String);
  }

  @protected
  String dco_decode_String(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as String;
  }

  @protected
  BatteryData dco_decode_battery_data(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    final arr = raw as List<dynamic>;
    if (arr.length != 3)
      throw Exception('unexpected arr length: expect 3 but see ${arr.length}');
    return BatteryData(
      capacityPercent: dco_decode_list_prim_u_8_strict(arr[0]),
      drainRateWatt: dco_decode_list_prim_f_32_strict(arr[1]),
      status: dco_decode_list_battery_state(arr[2]),
    );
  }

  @protected
  BatteryState dco_decode_battery_state(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return BatteryState.values[raw as int];
  }

  @protected
  bool dco_decode_bool(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as bool;
  }

  @protected
  BrightnessData dco_decode_brightness_data(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    final arr = raw as List<dynamic>;
    if (arr.length != 2)
      throw Exception('unexpected arr length: expect 2 but see ${arr.length}');
    return BrightnessData(
      deviceName: dco_decode_list_String(arr[0]),
      brightness: dco_decode_list_prim_u_32_strict(arr[1]),
    );
  }

  @protected
  double dco_decode_f_32(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as double;
  }

  @protected
  int dco_decode_i_32(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as int;
  }

  @protected
  List<String> dco_decode_list_String(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return (raw as List<dynamic>).map(dco_decode_String).toList();
  }

  @protected
  List<BatteryState> dco_decode_list_battery_state(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return (raw as List<dynamic>).map(dco_decode_battery_state).toList();
  }

  @protected
  Float32List dco_decode_list_prim_f_32_strict(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as Float32List;
  }

  @protected
  Uint32List dco_decode_list_prim_u_32_strict(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as Uint32List;
  }

  @protected
  Uint8List dco_decode_list_prim_u_8_strict(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as Uint8List;
  }

  @protected
  List<WifiData> dco_decode_list_wifi_data(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return (raw as List<dynamic>).map(dco_decode_wifi_data).toList();
  }

  @protected
  MprisData dco_decode_mpris_data(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    final arr = raw as List<dynamic>;
    if (arr.length != 9)
      throw Exception('unexpected arr length: expect 9 but see ${arr.length}');
    return MprisData(
      title: dco_decode_String(arr[0]),
      artist: dco_decode_list_String(arr[1]),
      album: dco_decode_String(arr[2]),
      imageUrl: dco_decode_String(arr[3]),
      duration: dco_decode_u_64(arr[4]),
      position: dco_decode_u_64(arr[5]),
      isPlaying: dco_decode_bool(arr[6]),
      canNext: dco_decode_bool(arr[7]),
      canPrevious: dco_decode_bool(arr[8]),
    );
  }

  @protected
  PowerProfiles dco_decode_power_profiles(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return PowerProfiles.values[raw as int];
  }

  @protected
  int dco_decode_u_32(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as int;
  }

  @protected
  BigInt dco_decode_u_64(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return dcoDecodeU64(raw);
  }

  @protected
  int dco_decode_u_8(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as int;
  }

  @protected
  void dco_decode_unit(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return;
  }

  @protected
  WifiData dco_decode_wifi_data(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    final arr = raw as List<dynamic>;
    if (arr.length != 3)
      throw Exception('unexpected arr length: expect 3 but see ${arr.length}');
    return WifiData(
      isConnected: dco_decode_bool(arr[0]),
      ssid: dco_decode_String(arr[1]),
      signalStrength: dco_decode_u_32(arr[2]),
    );
  }

  @protected
  WireplumberData dco_decode_wireplumber_data(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    final arr = raw as List<dynamic>;
    if (arr.length != 1)
      throw Exception('unexpected arr length: expect 1 but see ${arr.length}');
    return WireplumberData(
      volume: dco_decode_f_32(arr[0]),
    );
  }

  @protected
  AnyhowException sse_decode_AnyhowException(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var inner = sse_decode_String(deserializer);
    return AnyhowException(inner);
  }

  @protected
  String sse_decode_String(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var inner = sse_decode_list_prim_u_8_strict(deserializer);
    return utf8.decoder.convert(inner);
  }

  @protected
  BatteryData sse_decode_battery_data(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var var_capacityPercent = sse_decode_list_prim_u_8_strict(deserializer);
    var var_drainRateWatt = sse_decode_list_prim_f_32_strict(deserializer);
    var var_status = sse_decode_list_battery_state(deserializer);
    return BatteryData(
        capacityPercent: var_capacityPercent,
        drainRateWatt: var_drainRateWatt,
        status: var_status);
  }

  @protected
  BatteryState sse_decode_battery_state(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var inner = sse_decode_i_32(deserializer);
    return BatteryState.values[inner];
  }

  @protected
  bool sse_decode_bool(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getUint8() != 0;
  }

  @protected
  BrightnessData sse_decode_brightness_data(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var var_deviceName = sse_decode_list_String(deserializer);
    var var_brightness = sse_decode_list_prim_u_32_strict(deserializer);
    return BrightnessData(
        deviceName: var_deviceName, brightness: var_brightness);
  }

  @protected
  double sse_decode_f_32(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getFloat32();
  }

  @protected
  int sse_decode_i_32(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getInt32();
  }

  @protected
  List<String> sse_decode_list_String(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs

    var len_ = sse_decode_i_32(deserializer);
    var ans_ = <String>[];
    for (var idx_ = 0; idx_ < len_; ++idx_) {
      ans_.add(sse_decode_String(deserializer));
    }
    return ans_;
  }

  @protected
  List<BatteryState> sse_decode_list_battery_state(
      SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs

    var len_ = sse_decode_i_32(deserializer);
    var ans_ = <BatteryState>[];
    for (var idx_ = 0; idx_ < len_; ++idx_) {
      ans_.add(sse_decode_battery_state(deserializer));
    }
    return ans_;
  }

  @protected
  Float32List sse_decode_list_prim_f_32_strict(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var len_ = sse_decode_i_32(deserializer);
    return deserializer.buffer.getFloat32List(len_);
  }

  @protected
  Uint32List sse_decode_list_prim_u_32_strict(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var len_ = sse_decode_i_32(deserializer);
    return deserializer.buffer.getUint32List(len_);
  }

  @protected
  Uint8List sse_decode_list_prim_u_8_strict(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var len_ = sse_decode_i_32(deserializer);
    return deserializer.buffer.getUint8List(len_);
  }

  @protected
  List<WifiData> sse_decode_list_wifi_data(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs

    var len_ = sse_decode_i_32(deserializer);
    var ans_ = <WifiData>[];
    for (var idx_ = 0; idx_ < len_; ++idx_) {
      ans_.add(sse_decode_wifi_data(deserializer));
    }
    return ans_;
  }

  @protected
  MprisData sse_decode_mpris_data(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var var_title = sse_decode_String(deserializer);
    var var_artist = sse_decode_list_String(deserializer);
    var var_album = sse_decode_String(deserializer);
    var var_imageUrl = sse_decode_String(deserializer);
    var var_duration = sse_decode_u_64(deserializer);
    var var_position = sse_decode_u_64(deserializer);
    var var_isPlaying = sse_decode_bool(deserializer);
    var var_canNext = sse_decode_bool(deserializer);
    var var_canPrevious = sse_decode_bool(deserializer);
    return MprisData(
        title: var_title,
        artist: var_artist,
        album: var_album,
        imageUrl: var_imageUrl,
        duration: var_duration,
        position: var_position,
        isPlaying: var_isPlaying,
        canNext: var_canNext,
        canPrevious: var_canPrevious);
  }

  @protected
  PowerProfiles sse_decode_power_profiles(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var inner = sse_decode_i_32(deserializer);
    return PowerProfiles.values[inner];
  }

  @protected
  int sse_decode_u_32(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getUint32();
  }

  @protected
  BigInt sse_decode_u_64(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getBigUint64();
  }

  @protected
  int sse_decode_u_8(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getUint8();
  }

  @protected
  void sse_decode_unit(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
  }

  @protected
  WifiData sse_decode_wifi_data(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var var_isConnected = sse_decode_bool(deserializer);
    var var_ssid = sse_decode_String(deserializer);
    var var_signalStrength = sse_decode_u_32(deserializer);
    return WifiData(
        isConnected: var_isConnected,
        ssid: var_ssid,
        signalStrength: var_signalStrength);
  }

  @protected
  WireplumberData sse_decode_wireplumber_data(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var var_volume = sse_decode_f_32(deserializer);
    return WireplumberData(volume: var_volume);
  }

  @protected
  void sse_encode_AnyhowException(
      AnyhowException self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_String(self.message, serializer);
  }

  @protected
  void sse_encode_String(String self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_list_prim_u_8_strict(utf8.encoder.convert(self), serializer);
  }

  @protected
  void sse_encode_battery_data(BatteryData self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_list_prim_u_8_strict(self.capacityPercent, serializer);
    sse_encode_list_prim_f_32_strict(self.drainRateWatt, serializer);
    sse_encode_list_battery_state(self.status, serializer);
  }

  @protected
  void sse_encode_battery_state(BatteryState self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.index, serializer);
  }

  @protected
  void sse_encode_bool(bool self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putUint8(self ? 1 : 0);
  }

  @protected
  void sse_encode_brightness_data(
      BrightnessData self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_list_String(self.deviceName, serializer);
    sse_encode_list_prim_u_32_strict(self.brightness, serializer);
  }

  @protected
  void sse_encode_f_32(double self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putFloat32(self);
  }

  @protected
  void sse_encode_i_32(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putInt32(self);
  }

  @protected
  void sse_encode_list_String(List<String> self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    for (final item in self) {
      sse_encode_String(item, serializer);
    }
  }

  @protected
  void sse_encode_list_battery_state(
      List<BatteryState> self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    for (final item in self) {
      sse_encode_battery_state(item, serializer);
    }
  }

  @protected
  void sse_encode_list_prim_f_32_strict(
      Float32List self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    serializer.buffer.putFloat32List(self);
  }

  @protected
  void sse_encode_list_prim_u_32_strict(
      Uint32List self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    serializer.buffer.putUint32List(self);
  }

  @protected
  void sse_encode_list_prim_u_8_strict(
      Uint8List self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    serializer.buffer.putUint8List(self);
  }

  @protected
  void sse_encode_list_wifi_data(
      List<WifiData> self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    for (final item in self) {
      sse_encode_wifi_data(item, serializer);
    }
  }

  @protected
  void sse_encode_mpris_data(MprisData self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_String(self.title, serializer);
    sse_encode_list_String(self.artist, serializer);
    sse_encode_String(self.album, serializer);
    sse_encode_String(self.imageUrl, serializer);
    sse_encode_u_64(self.duration, serializer);
    sse_encode_u_64(self.position, serializer);
    sse_encode_bool(self.isPlaying, serializer);
    sse_encode_bool(self.canNext, serializer);
    sse_encode_bool(self.canPrevious, serializer);
  }

  @protected
  void sse_encode_power_profiles(PowerProfiles self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.index, serializer);
  }

  @protected
  void sse_encode_u_32(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putUint32(self);
  }

  @protected
  void sse_encode_u_64(BigInt self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putBigUint64(self);
  }

  @protected
  void sse_encode_u_8(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putUint8(self);
  }

  @protected
  void sse_encode_unit(void self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
  }

  @protected
  void sse_encode_wifi_data(WifiData self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_bool(self.isConnected, serializer);
    sse_encode_String(self.ssid, serializer);
    sse_encode_u_32(self.signalStrength, serializer);
  }

  @protected
  void sse_encode_wireplumber_data(
      WireplumberData self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_f_32(self.volume, serializer);
  }
}
