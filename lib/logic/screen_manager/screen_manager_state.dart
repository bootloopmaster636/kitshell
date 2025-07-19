part of 'screen_manager_bloc.dart';

@freezed
sealed class ScreenManagerState with _$ScreenManagerState {
  const factory ScreenManagerState.initial() = ScreenManagerStateInitial;
  const factory ScreenManagerState.loaded({
    required bool isPopupShown,
    required PopupWidget popupShown,
    required WidgetPosition position,
  }) = ScreenManagerStateLoaded;
}
