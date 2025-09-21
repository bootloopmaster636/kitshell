import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kitshell/data/repository/launchbar/wm_iface_repo.dart';
import 'package:kitshell/src/rust/api/wm_interface/base.dart';

part 'workspaces_bloc.freezed.dart';
part 'workspaces_event.dart';
part 'workspaces_state.dart';

class WorkspacesBloc extends Bloc<WorkspacesEvent, WorkspacesState> {
  WorkspacesBloc({required WmIfaceRepo wmIfaceRepo})
    : _wmIfaceRepo = wmIfaceRepo,
      super(const WorkspacesState.initial()) {
    on<WorkspacesEventStarted>(_onStarted);
    on<WorkspacesEventSwitched>(_onSwitched);
  }

  final WmIfaceRepo _wmIfaceRepo;

  Future<void> _onStarted(
    WorkspacesEventStarted event,
    Emitter<WorkspacesState> emit,
  ) async {
    // Stream is initialized by [LaunchbarBloc], so no need to init here
    return emit.onEach(
      _wmIfaceRepo.windowManagerStateStream,
      onData: (data) {
        emit(WorkspacesStateLoaded(workspace: data.workspaces));
      },
    );
  }

  Future<void> _onSwitched(
    WorkspacesEventSwitched event,
    Emitter<WorkspacesState> emit,
  ) async {
    await _wmIfaceRepo.wmFocusWorkspace(event.workspaceId);
  }
}
