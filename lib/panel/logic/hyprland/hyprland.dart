import 'dart:async';

import 'package:kitshell/const.dart';
import 'package:kitshell/src/rust/api/hyprland.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hyprland.g.dart';

@riverpod
class HyprlandLogic extends _$HyprlandLogic {
  @override
  Future<HyprlandData> build() async {
    await startPolling();
    return const HyprlandData(activeWindowTitle: '', activeWorkspace: WorkspaceData(id: 0, name: 'Unknown'));
  }

  @override
  bool updateShouldNotify(AsyncValue<HyprlandData> previous, AsyncValue<HyprlandData> next) {
    return previous.value?.activeWindowTitle != next.value?.activeWindowTitle ||
        previous.value?.activeWorkspace != next.value?.activeWorkspace;
  }

  Future<void> startPolling() async {
    Timer.periodic(pollingRate, (timer) async {
      final data = await getHyprlandData();
      state = AsyncData(data);
    });
  }
}
