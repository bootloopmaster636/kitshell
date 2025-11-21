import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kitshell/data/repository/quick_settings/internet/wlan_repo.dart';
import 'package:kitshell/etc/utitity/logger.dart';
import 'package:kitshell/src/rust/api/quick_settings/network/network_devices.dart';
import 'package:kitshell/src/rust/api/quick_settings/network/wlan.dart';

part 'wlan_event.dart';
part 'wlan_state.dart';
part 'wlan_bloc.freezed.dart';

/// Bloc that manages WLAN device
class WlanBloc extends Bloc<WlanEvent, WlanState> {
  WlanBloc()
    : super(
        const WlanState(
          accessPoints: [],
          devState: InternetDeviceState.unknown,
          isActive: false,
          isScanning: false,
          iface: '',
        ),
      ) {
    on<WlanEventStarted>(_onStarted);
    on<WlanEventScanned>(_onScanned);
    on<WlanEventConnect>(_onConnect);
    on<WlanEventDisconnect>(_onDisconnect);

    on<_WlanEventListenDevState>(_onListenDevState);
    on<_WlanEventListenApList>(_onListenApList);
  }

  final WlanRepo _wlanRepo = WlanRepo();

  Future<void> _onStarted(
    WlanEventStarted event,
    Emitter<WlanState> emit,
  ) async {
    emit(state.copyWith(isScanning: true));
    await _wlanRepo.initDevice(event.interface);
    emit(state.copyWith(isScanning: false, iface: event.interface));
    add(const _WlanEventListenDevState());
    add(const _WlanEventListenApList());
    add(const WlanEventScanned());
  }

  Future<void> _onScanned(
    WlanEventScanned event,
    Emitter<WlanState> emit,
  ) async {
    emit(state.copyWith(isScanning: true));
    await _wlanRepo.fetchApList(withScan: true);
    emit(state.copyWith(isScanning: false));
  }

  Future<void> _onConnect(
    WlanEventConnect event,
    Emitter<WlanState> emit,
  ) async {
    await _wlanRepo.connect(
      apPath: event.apPath,
      ssid: event.ssid,
      password: event.password,
    );
    await Future<void>.delayed(const Duration(seconds: 1));
    add(const WlanEventScanned());
  }

  Future<void> _onDisconnect(
    WlanEventDisconnect event,
    Emitter<WlanState> emit,
  ) async {
    await _wlanRepo.disconnect();
    await Future<void>.delayed(const Duration(seconds: 1));
    add(const WlanEventScanned());
  }

  Future<void> _onListenDevState(
    _WlanEventListenDevState event,
    Emitter<WlanState> emit,
  ) async {
    await emit.forEach(
      _wlanRepo.deviceState.stream,
      onData: (data) {
        logger.i('WlanBloc: Now state is $data');
        return state.copyWith(devState: data);
      },
    );
  }

  Future<void> _onListenApList(
    _WlanEventListenApList event,
    Emitter<WlanState> emit,
  ) async {
    await emit.forEach(
      _wlanRepo.accessPoints.stream,
      onData: (data) {
        final activeAP = data.where((e) => e.isActive).firstOrNull;
        return state.copyWith(
          accessPoints: data,
          activeDevicePath: activeAP?.apPath,
        );
      },
    );
  }
}
