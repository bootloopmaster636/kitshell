import 'package:injectable/injectable.dart';
import 'package:kitshell/src/rust/api/quick_settings/network/wlan.dart';

/// This repo manages a Wi-Fi/WLAN devices. That includes scanning,
/// listing APs, and managing connection to AP.
@injectable
class WlanRepo {
  late WlanDevice _wlanDevice;

  /// Initializes this device
  Future<void> init(String interface) async {
    _wlanDevice = await createWlanDevice(fromIface: interface);
  }

  /// Dispose the device, this should be called when the device
  /// is not used / does not exist anymore.
  void dispose() {
    _wlanDevice.dispose();
  }
}
