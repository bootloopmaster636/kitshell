part of 'qs_brightness_bloc.dart';

@freezed
sealed class QsBrightnessEvent with _$QsBrightnessEvent {
  const factory QsBrightnessEvent.started() = QsBrightnessEventStarted;
}
