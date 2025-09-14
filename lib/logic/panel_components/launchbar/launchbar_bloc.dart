import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kitshell/data/model/runtime/appinfo/appinfo_model.dart';
import 'package:kitshell/data/repository/launchbar/launchbar_repo.dart';

part 'launchbar_bloc.freezed.dart';
part 'launchbar_event.dart';
part 'launchbar_state.dart';

@singleton
class LaunchbarBloc extends Bloc<LaunchbarEvent, LaunchbarState> {
  LaunchbarBloc({required LaunchbarRepo launcbarRepo})
    : _launchbarRepo = launcbarRepo,
      super(const LaunchbarStateInitial()) {
    on<LaunchbarEventStarted>(_started);
    on<LaunchbarEventAdded>(_added);
    on<LaunchbarEventSwapPinned>(_swapPinned);
  }

  final LaunchbarRepo _launchbarRepo;

  Future<void> _started(
    LaunchbarEventStarted event,
    Emitter<LaunchbarState> emit,
  ) async {
    await _launchbarRepo.initDb();
    await _launchbarRepo.startWatchingAppList();
    emit(const LaunchbarStateLoaded(pinned: [], running: []));
    return emit.onEach(
      _launchbarRepo.pinnedAppsList,
      onData: (data) {
        if (state is! LaunchbarStateLoaded) return;
        final loadedState = state as LaunchbarStateLoaded;

        emit(loadedState.copyWith(pinned: data));
      },
    );
  }

  Future<void> _added(
    LaunchbarEventAdded event,
    Emitter<LaunchbarState> emit,
  ) async {
    if (state is! LaunchbarStateLoaded) return;
    return _launchbarRepo.addNew(event.appId);
  }

  Future<void> _swapPinned(
    LaunchbarEventSwapPinned event,
    Emitter<LaunchbarState> emit,
  ) async {
    if (state is! LaunchbarStateLoaded) return;
    final loadedState = state as LaunchbarStateLoaded;
    final pinnedEntries = [...loadedState.pinned];

    // Do swap operation
    final oldIndex = event.from;
    var newIndex = event.to;

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = pinnedEntries.removeAt(oldIndex);
    pinnedEntries.insert(newIndex, item);

    // Refresh db index
    for (var i = 0; i < pinnedEntries.length; i++) {
      await _launchbarRepo.changeIndex(
        appId: pinnedEntries[i].entry.id,
        newIdx: i,
      );
    }
  }
}
