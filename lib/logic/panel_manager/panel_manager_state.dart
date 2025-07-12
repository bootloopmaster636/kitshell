part of 'panel_manager_bloc.dart';

@freezed
sealed class PanelManagerState with _$PanelManagerState {
  const factory PanelManagerState.initial() = PanelManagerStateInitial;
  const factory PanelManagerState.loaded({
    required List<Widget> componentsLeft,
    required List<Widget> componentsCenter,
    required List<Widget> componentsRight,
  }) = PanelManagerStateLoaded;
}
