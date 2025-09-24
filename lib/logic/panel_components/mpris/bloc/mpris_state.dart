part of 'mpris_bloc.dart';

@freezed
sealed class MprisState with _$MprisState {
  const factory MprisState.initial() = MprisStateInitial;
  const factory MprisState.loaded(TrackProgress trackProgress) =
      MprisStateLoaded;
}
