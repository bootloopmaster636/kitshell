part of 'qs_battery_bloc.dart';

@freezed
sealed class QsBatteryState with _$QsBatteryState {
  const factory QsBatteryState.initial() = QsBatteryStateInitial;
  const factory QsBatteryState.loaded(List<BatteryInfo> batteryInfos) =
      QsBatteryStateLoaded;
}
