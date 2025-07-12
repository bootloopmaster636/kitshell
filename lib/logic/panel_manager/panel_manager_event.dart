part of 'panel_manager_bloc.dart';

@freezed
sealed class PanelManagerEvent with _$PanelManagerEvent {
  const factory PanelManagerEvent.started() = PanelManagerEventStarted;
}
