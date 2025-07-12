part of 'screen_manager_bloc.dart';

@freezed
sealed class ScreenManagerEvent with _$ScreenManagerEvent {
  const factory ScreenManagerEvent.started() = ScreenManagerEventStarted;
  const factory ScreenManagerEvent.openPopup({
    required PopupWidget popupToShow,
    required WidgetPosition position,
  }) = ScreenManagerEventOpenPopup;
  const factory ScreenManagerEvent.closePopup() = ScreenManagerEventClosePopup;
}
