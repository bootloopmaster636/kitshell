import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kitshell/data/repository/quick_settings/internet/wlan_repo.dart';
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
        ),
      ) {
    on<WlanEventStarted>(_onStarted);
    on<WlanEventScanned>(_onScanned);
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
    emit(state.copyWith(isScanning: false));
    add(const _WlanEventListenDevState());
    add(const _WlanEventListenApList());
  }

  Future<void> _onScanned(
    WlanEventScanned event,
    Emitter<WlanState> emit,
  ) async {
    emit(state.copyWith(isScanning: true));
    await _wlanRepo.fetchApList(withScan: true);
    emit(state.copyWith(isScanning: false));
  }

  Future<void> _onListenDevState(
    _WlanEventListenDevState event,
    Emitter<WlanState> emit,
  ) async {
    await emit.forEach(
      _wlanRepo.deviceState.stream,
      onData: (data) => state.copyWith(devState: data),
    );
  }

  Future<void> _onListenApList(
    _WlanEventListenApList event,
    Emitter<WlanState> emit,
  ) async {
    await emit.forEach(
      _wlanRepo.accessPoints.stream,
      onData: (data) => state.copyWith(accessPoints: data),
    );
  }
}
