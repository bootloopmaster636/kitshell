import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:kitshell/etc/utitity/logger.dart';
import 'package:kitshell/src/rust/api/quick_settings/network/network_devices.dart';
import 'package:kitshell/src/rust/api/quick_settings/network/wlan.dart';

/// This repo manages a Wi-Fi/WLAN devices. That includes scanning,
/// listing APs, and managing connection to AP.
@injectable
class WlanRepo {
  late WlanDevice _wlanDevice;

  /// This WLAN device state (connected or not, etc.)
  StreamController<InternetDeviceState> deviceState = StreamController();
  late StreamSubscription<InternetDeviceState> _deviceStateStream;

  /// Access point currently detected by this device
  StreamController<List<AccessPoint>> accessPoints = StreamController();

  /// Initializes this device, this should be called
  Future<void> initDevice(String interface) async {
    logger.i('WlanRepo ($interface): Initializing device');
    _wlanDevice = await createWlanDevice(fromIface: interface);
    await _wlanDevice.init();

    deviceState = StreamController();
    _deviceStateStream = _wlanDevice.monitorDeviceState().listen((data) {
      deviceState.add(data);
    });
    logger.i('WlanRepo ($interface): Device init from Flutter completed');
  }

  /// Get AP list that has been scanned by the device
  Future<void> fetchApList({required bool withScan}) async {
    logger.i('WlanRepo: Fetch AP list started');
    if (withScan) {
      logger.i('WlanRepo: Scanning for AP...');
      await _wlanDevice.requestScan();
    }

    logger.i('WlanRepo: Getting AP list...');
    final apList = await _wlanDevice.getAccessPoints();

    logger.i('WlanRepo: Triggering AP list change...');
    accessPoints.add(apList);
  }

  /// Connect
  Future<void> connect({
    required String apPath,
    required String ssid,
    String? password,
  }) async {
    logger.i('WlanRepo: Connecting to wifi $ssid');
    await _wlanDevice.connectToAp(
      ssid: ssid,
      apPath: apPath,
      password: password,
      isApSaved: true,
    );
    logger.i('WlanRepo: Connected to $ssid');
  }

  /// Disconnect current connection
  Future<void> disconnect() async {
    logger.i('WlanRepo: Disconnecting from AP');
    await _wlanDevice.disconnect();
    logger.i('WlanRepo: Disconnected');
  }

  /// Dispose the device, this should be called when the device
  /// is not used / does not exist anymore.
  Future<void> dispose() async {
    await _deviceStateStream.cancel();
    _wlanDevice.dispose();
  }
}
