import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kitshell/etc/config.dart';
import 'package:kitshell/etc/panel_enum.dart';
import 'package:kitshell/src/rust/api/display_info.dart';
import 'package:wayland_layer_shell/types.dart';
import 'package:wayland_layer_shell/wayland_layer_shell.dart';

part 'screen_manager_bloc.freezed.dart';
part 'screen_manager_event.dart';
part 'screen_manager_state.dart';

@singleton
class ScreenManagerBloc extends Bloc<ScreenManagerEvent, ScreenManagerState> {
  ScreenManagerBloc() : super(const ScreenManagerStateInitial()) {
    on<ScreenManagerEventStarted>(_onStarted);
    on<ScreenManagerEventOpenPopup>(_onOpenPopup, transformer: restartable());
    on<ScreenManagerEventClosePopup>(_onClosePopup, transformer: restartable());
  }

  final layerShellManager = WaylandLayerShell();

  Future<void> _onStarted(
    ScreenManagerEventStarted event,
    Emitter<ScreenManagerState> emit,
  ) async {
    // Get display resolution info
    final displayInfo = getPrimaryDisplaySize();
    await layerShellManager.initialize(
      displayInfo.widthPx,
      panelDefaultHeightPx,
    );

    // Set panel anchor to bottom
    await layerShellManager.setAnchor(ShellEdge.edgeBottom, true);

    // Set keyboard interactivity to onDemand
    // see: https://wayland.app/protocols/wlr-layer-shell-unstable-v1#zwlr_layer_surface_v1:enum:keyboard_interactivity:entry:on_demand
    await layerShellManager.setKeyboardMode(
      ShellKeyboardMode.keyboardModeOnDemand,
    );

    // Set to top layer
    await layerShellManager.setLayer(ShellLayer.layerTop);

    // Set exclusive mode to only bottom panel
    await layerShellManager.setExclusiveZone(panelDefaultHeightPx);

    emit(const ScreenManagerStateLoaded(isPopupShown: false));
  }

  Future<void> _onOpenPopup(
    ScreenManagerEventOpenPopup event,
    Emitter<ScreenManagerState> emit,
  ) async {
    // Get display resolution info
    final displayInfo = getPrimaryDisplaySize();
    await layerShellManager.initialize(
      displayInfo.widthPx,
      displayInfo.heightPx,
    );
    emit(
      ScreenManagerStateLoaded(
        isPopupShown: true,
        popupShown: event.popupToShow,
        position: event.position,
      ),
    );
  }

  Future<void> _onClosePopup(
    ScreenManagerEventClosePopup event,
    Emitter<ScreenManagerState> emit,
  ) async {
    // Get display resolution info
    final displayInfo = getPrimaryDisplaySize();

    // Do closing animation and etc
    emit(
      const ScreenManagerStateLoaded(
        isPopupShown: false,
      ),
    );
    await Future<void>.delayed(popupOpenCloseDuration);

    // Reset layer state
    await layerShellManager.initialize(
      displayInfo.widthPx,
      panelDefaultHeightPx,
    );
  }
}
