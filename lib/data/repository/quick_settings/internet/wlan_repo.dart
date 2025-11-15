import 'dart:async';

import 'package:injectable/injectable.dart';
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
    _wlanDevice = await createWlanDevice(fromIface: interface);
    await _wlanDevice.init();
    unawaited(_wlanDevice.requestScan());

    deviceState = StreamController();
    _deviceStateStream = _wlanDevice.monitorDeviceState().listen((data) {
      deviceState.add(data);
    });
  }

  /// Get AP list that has been scanned by the device
  Future<void> fetchApList({required bool withScan}) async {
    if (withScan) {
      await _wlanDevice.requestScan();
    }
    accessPoints.add(await _wlanDevice.getAccessPoints());
  }

  /// Dispose the device, this should be called when the device
  /// is not used / does not exist anymore.
  Future<void> dispose() async {
    await _deviceStateStream.cancel();
    _wlanDevice.dispose();
  }
}
