part of 'cava_bloc.dart';

@freezed
sealed class CavaEvent with _$CavaEvent {
  const factory CavaEvent.started() = CavaEventStarted;
}
