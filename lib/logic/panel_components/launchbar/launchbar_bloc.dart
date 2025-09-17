import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kitshell/data/model/runtime/appinfo/appinfo_model.dart';
import 'package:kitshell/data/repository/appmenu/app_list_repo.dart';
import 'package:kitshell/data/repository/launchbar/launchbar_repo.dart';
import 'package:kitshell/data/repository/launchbar/wm_iface_repo.dart';
import 'package:kitshell/etc/utitity/logger.dart';
import 'package:kitshell/src/rust/api/wm_interface/base.dart';

part 'launchbar_bloc.freezed.dart';
part 'launchbar_event.dart';
part 'launchbar_state.dart';

@singleton
class LaunchbarBloc extends Bloc<LaunchbarEvent, LaunchbarState> {
  LaunchbarBloc({
    required LaunchbarRepo launcbarRepo,
    required WmIfaceRepo wmIfaceRepo,
    required AppListRepo appListRepo,
  }) : _launchbarRepo = launcbarRepo,
       _wmIfaceRepo = wmIfaceRepo,
       _appListRepo = appListRepo,
       super(const LaunchbarStateInitial()) {
    on<LaunchbarEventApplistWatched>(_watchApplist);
    on<LaunchbarEventWmEventsWatched>(_watchWmWindows);
    on<LaunchbarEventAdded>(_added);
    on<LaunchbarEventSwapPinned>(_swapPinned);
  }

  final LaunchbarRepo _launchbarRepo;
  final WmIfaceRepo _wmIfaceRepo;
  final AppListRepo _appListRepo;

  Future<void> _watchApplist(
    LaunchbarEventApplistWatched event,
    Emitter<LaunchbarState> emit,
  ) async {
    await _launchbarRepo.initDb();
    await _launchbarRepo.startWatchingAppList();
    emit(
      const LaunchbarStateLoaded(pinnedApps: [], runningApps: [], items: []),
    );

    return emit.onEach(
      _launchbarRepo.pinnedAppsList,
      onData: (data) {
        if (state is! LaunchbarStateLoaded) return;
        final loadedState = state as LaunchbarStateLoaded;

        final result = _processData(
          pinnedApps: data,
          runningApps: loadedState.runningApps,
          appList: _appListRepo.current,
        );
        emit(loadedState.copyWith(pinnedApps: data, items: result));
      },
      onError: (e, st) {
        logger.e('LaunchbarBloc | watchAppList: $e');
      },
    );
  }

  Future<void> _watchWmWindows(
    LaunchbarEventWmEventsWatched event,
    Emitter<LaunchbarState> emit,
  ) async {
    await _wmIfaceRepo.load();
    return emit.onEach(
      _wmIfaceRepo.windowManagerStateStream,
      onData: (data) {
        if (state is! LaunchbarStateLoaded) return;
        final loadedState = state as LaunchbarStateLoaded;

        final itemStateList = data.launchbar;

        final result = _processData(
          pinnedApps: loadedState.pinnedApps,
          runningApps: itemStateList,
          appList: _appListRepo.current,
        );
        emit(loadedState.copyWith(runningApps: itemStateList, items: result));
      },
      onError: (e, st) {
        logger.e('LaunchbarBloc | watchWmWindows: $e');
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
    final pinnedEntries = [...loadedState.pinnedApps];

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
        appHash: pinnedEntries[i].entry.id,
        newIdx: i,
      );
    }
  }

  List<LaunchbarItem> _processData({
    // List of pinned apps
    required List<AppInfoModel> pinnedApps,

    // List of running apps
    required List<LaunchbarItemState> runningApps,

    // List of apps thats available, for lookup reason only
    required List<AppInfoModel> appList,
  }) {
    List<LaunchbarItemState> mutRunningApps = [...runningApps];
    List<LaunchbarItem> result = [];

    // First, we process pinned apps first
    for (final pinnedApp in pinnedApps) {
      final runInfoIdx = mutRunningApps.indexWhere(
        (e) => '${e.appId}'.contains(pinnedApp.entry.appId),
      );

      if (runInfoIdx != -1) {
        // Matching app found, we pop it from runningApp list to prevent
        // duplication in next stage
        final runInfo = mutRunningApps.removeAt(runInfoIdx);

        result.add(
          LaunchbarItem(
            isPinned: true,
            appInfo: pinnedApp,
            windowInfo: runInfo,
          ),
        );
      } else {
        // Matching app not found in running app, that means we did not have
        // that app open or it does not have the same appId (dont blame us for
        // that one :) )

        result.add(LaunchbarItem(isPinned: true, appInfo: pinnedApp));
      }
    }

    // And.. process the rest of running app
    for (final runningApp in mutRunningApps) {
      final appInfoIdx = appList.indexWhere(
        (e) =>
            '${runningApp.appId}'.contains(e.entry.appId) ||
            '${runningApp.windowTitle}'.contains(e.entry.name),
      );

      result.add(
        LaunchbarItem(
          isPinned: false,
          appInfo: appInfoIdx != -1 ? appList[appInfoIdx] : null,
          windowInfo: runningApp,
        ),
      );
    }

    return result;
  }
}
