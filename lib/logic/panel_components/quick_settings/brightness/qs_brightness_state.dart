part of 'qs_brightness_bloc.dart';

@freezed
sealed class QsBrightnessState with _$QsBrightnessState {
  const factory QsBrightnessState.initial() = QsBrightnessStateInitial;
  const factory QsBrightnessState.loaded(List<BacklightInfo> brightness) =
      QsBrightnessStateLoaded;
}
