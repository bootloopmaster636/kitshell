part of 'workspaces_bloc.dart';

@freezed
sealed class WorkspacesState with _$WorkspacesState {
  const factory WorkspacesState.initial() = WorkspacesStateInitial;

  const factory WorkspacesState.loaded({
    required List<WorkspaceState> workspace,
  }) = WorkspacesStateLoaded;
}
