part of 'wlan_bloc.dart';

@freezed
sealed class WlanEvent with _$WlanEvent {
  const factory WlanEvent.started(String interface) = WlanEventStarted;
  const factory WlanEvent.scan() = WlanEventScanned;
  const factory WlanEvent.connect({
    required String apPath,
    required String ssid,
    String? password,
  }) = WlanEventConnect;
  const factory WlanEvent.disconnect() = WlanEventDisconnect;

  const factory WlanEvent.listenDevState() = _WlanEventListenDevState;
  const factory WlanEvent.listenApList() = _WlanEventListenApList;
}
