part of 'qs_battery_bloc.dart';

@freezed
sealed class QsBatteryEvent with _$QsBatteryEvent {
  const factory QsBatteryEvent.started() = QsBatteryEventStarted;
}
