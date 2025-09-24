part of 'mpris_bloc.dart';

@freezed
sealed class MprisEvent with _$MprisEvent {
  const factory MprisEvent.started() = MprisEventStarted;
}
