part of 'workspaces_bloc.dart';

@freezed
sealed class WorkspacesEvent with _$WorkspacesEvent {
  const factory WorkspacesEvent.started() = WorkspacesEventStarted;

  const factory WorkspacesEvent.switched({required int workspaceId}) =
      WorkspacesEventSwitched;
}
