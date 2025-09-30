part of 'panel_gesture_cubit.dart';

@freezed
sealed class PanelGestureState with _$PanelGestureState {
  const factory PanelGestureState({
    required bool readyToClose,
  }) = _PanelGestureState;
}
