import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:kitshell/src/rust/api/wm_interface/base.dart';
import 'package:kitshell/src/rust/api/wm_interface/niri.dart';

/// {@template WmIfaceRepo}
/// Class to get window manager info (like opened window or workspaces)
/// {@endtemplate}
@singleton
class WmIfaceRepo {
  /// {@macro WmIfaceRepo}
  WmIfaceRepo() : _controller = StreamController<WmState>.broadcast();
  final StreamController<WmState> _controller;
  late StreamSubscription<WmState> _stateStream;

  /// Get window manager state by stream
  Stream<WmState> get windowManagerStateStream {
    return _controller.stream;
  }

  /// Get current window manager state (non reactive)
  late WmState currentWindowManagerState;

  /// Get current WM used by user
  WindowManager currentWm = WindowManager.unsupported;

  /// Detect WM and start streaming state
  Future<void> load() async {
    currentWm = await detectCurrentWm();
    switch (currentWm) {
      case WindowManager.niri:
        _stateStream = Niri.watchLaunchbarEvents().listen(_controller.add);
      case WindowManager.unsupported:
        return;
    }
  }

  /// Focus to selected window ID
  Future<void> wmFocusWindow(int windowId) async {
    switch (currentWm) {
      case WindowManager.niri:
        await Niri.focusWindow(windowId: BigInt.from(windowId));
      case WindowManager.unsupported:
        return;
    }
  }

  /// Close selected window ID
  Future<void> wmCloseWindow(int windowId) async {
    switch (currentWm) {
      case WindowManager.niri:
        await Niri.closeWindow(windowId: BigInt.from(windowId));
      case WindowManager.unsupported:
        return;
    }
  }

  /// Switch to selected workspace
  Future<void> wmFocusWorkspace(int workspaceId) async {
    switch (currentWm) {
      case WindowManager.niri:
        await Niri.switchWorkspace(workspaceId: BigInt.from(workspaceId));
      case WindowManager.unsupported:
        return;
    }
  }

  /// Dispose wm stream and release resources
  Future<void> dispose() async {
    await _stateStream.cancel();
    await _controller.close();
  }
}
