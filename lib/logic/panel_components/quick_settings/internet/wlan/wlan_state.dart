part of 'wlan_bloc.dart';

@freezed
sealed class WlanState with _$WlanState {
  const factory WlanState({
    required bool isActive,
    required bool isScanning,
    required List<AccessPoint> accessPoints,
    required InternetDeviceState devState,
  }) = _WlanState;
}
