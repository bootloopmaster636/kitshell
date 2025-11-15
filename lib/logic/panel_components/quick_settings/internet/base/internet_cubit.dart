import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kitshell/etc/utitity/logger.dart';
import 'package:kitshell/logic/panel_components/quick_settings/internet/wlan/wlan_bloc.dart';
import 'package:kitshell/src/rust/api/quick_settings/network/network_devices.dart';

part 'internet_state.dart';
part 'internet_cubit.freezed.dart';

/// Manages internet devices, for implementation detail
/// for each device, go to the respective BLoCs of the device.
@singleton
class InternetCubit extends Cubit<InternetState> {
  InternetCubit() : super(const InternetStateInitial());

  /// Start managing network devices.
  ///
  /// Will scan for any network devices and start its
  /// respective BLoC.
  Future<void> start() async {
    final devices = await getNetworkDevices();

    var supportedDevicesNum = 0;
    final wlanBlocs = <WlanBloc>[];

    for (final device in devices) {
      switch (device.devType) {
        case DeviceType.wifi:
          logger.i(
            'InternetCubit: Detected device type Wi-Fi, starting service...',
          );
          final manager = WlanBloc();
          manager.add(WlanEventStarted(device.iface));
          wlanBlocs.add(manager);

          supportedDevicesNum++;
        case DeviceType.eth:
        case DeviceType.modem:
        case DeviceType.unknown:
          logger.i(
            'InternetCubit: Detected device with unknown/unsupported type: ${device.devType}',
          );
      }
    }

    if (supportedDevicesNum == 0) {
      emit(const InternetStateUnsupported());
      return;
    }

    emit(InternetStateLoaded(wlanDevices: wlanBlocs));
  }
}
