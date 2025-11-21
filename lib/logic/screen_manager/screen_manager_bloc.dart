import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kitshell/etc/utitity/config.dart';
import 'package:kitshell/etc/utitity/logger.dart';
import 'package:kitshell/logic/screen_manager/panel_enum.dart';
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
    on<ScreenManagerEventOpenPopup>(_onOpenPopup, transformer: droppable());
    on<ScreenManagerEventClosePopup>(_onClosePopup, transformer: droppable());
  }

  final _layerShellManager = WaylandLayerShell();

  Future<void> _onStarted(
    ScreenManagerEventStarted event,
    Emitter<ScreenManagerState> emit,
  ) async {
    // Get display resolution info
    final displays = await getDisplayInfo();
    final displayInfo = displays.last;
    await _layerShellManager.initialize(
      displayInfo.widthPx,
      panelDefaultHeightPx,
    );

    // Set panel anchor to bottom
    await _layerShellManager.setAnchor(ShellEdge.edgeBottom, true);

    // Set keyboard interactivity to onDemand
    // see: https://wayland.app/protocols/wlr-layer-shell-unstable-v1#zwlr_layer_surface_v1:enum:keyboard_interactivity:entry:on_demand
    await _layerShellManager.setKeyboardMode(
      ShellKeyboardMode.keyboardModeOnDemand,
    );

    // Set to top layer
    await _layerShellManager.setLayer(ShellLayer.layerTop);

    // Set exclusive mode to only bottom panel
    await _layerShellManager.setExclusiveZone(panelDefaultHeightPx);

    // Set where shell appear. Shell will appear on primary monitor
    await _layerShellManager.setMonitor(
      Monitor(displayInfo.idx, displayInfo.name),
    );

    logger.i(
      'Shell has appeared '
      'on display ${displayInfo.name} (${displayInfo.idx})',
    );
    emit(
      ScreenManagerStateLoaded(
        isPopupShown: false,
        popupShown: PopupWidget.appMenu,
        position: .center,
        displays: displays,
      ),
    );
  }

  Future<void> _onOpenPopup(
    ScreenManagerEventOpenPopup event,
    Emitter<ScreenManagerState> emit,
  ) async {
    if (state is! ScreenManagerStateLoaded) return;
    final loadedState = state as ScreenManagerStateLoaded;

    // Close panel if user clicked on the same component/widget, then return
    if (loadedState.popupShown == event.popupToShow &&
        loadedState.isPopupShown) {
      add(const ScreenManagerEventClosePopup());
      return;
    }

    // Get display resolution info
    final displayInfo = loadedState.displays.last;
    await _layerShellManager.initialize(
      displayInfo.widthPx,
      displayInfo.heightPx,
    );
    await _layerShellManager.setLayer(ShellLayer.layerOverlay);
    await _layerShellManager.setKeyboardMode(
      ShellKeyboardMode.keyboardModeExclusive,
    );
    emit(
      loadedState.copyWith(
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
    if (state is! ScreenManagerStateLoaded) return;
    final loadedState = state as ScreenManagerStateLoaded;

    // Get display resolution info
    final displayInfo = loadedState.displays.last;

    // Do closing animation and etc
    emit(
      loadedState.copyWith(isPopupShown: false, popupShown: PopupWidget.none),
    );
    await Future<void>.delayed(popupOpenCloseDuration);

    // Reset layer state
    await _layerShellManager.setLayer(ShellLayer.layerTop);
    await _layerShellManager.setKeyboardMode(
      ShellKeyboardMode.keyboardModeOnDemand,
    );
    await _layerShellManager.initialize(
      displayInfo.widthPx,
      panelDefaultHeightPx,
    );
  }
}
