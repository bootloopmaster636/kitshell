import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wayland_layer_shell/types.dart';
import 'package:wayland_layer_shell/wayland_layer_shell.dart';

part 'layer_shell.freezed.dart';
part 'layer_shell.g.dart';

@Freezed()
class LayerShellData with _$LayerShellData {
  const factory LayerShellData({
    required int panelWidth,
    required int panelHeight,
    required ShellEdge anchor,
    required ShellLayer layer,
    Monitor? monitor,
  }) = _LayerShellData;
}

@riverpod
class LayerShellLogic extends _$LayerShellLogic {
  @override
  Future<LayerShellData> build() async {
    final data = const LayerShellData(
      panelWidth: 1366,
      panelHeight: 48,
      anchor: ShellEdge.edgeBottom,
      layer: ShellLayer.layerOverlay,
    );
    final waylandLayerShellPlugin = WaylandLayerShell();
    await waylandLayerShellPlugin.setKeyboardMode(ShellKeyboardMode.keyboardModeOnDemand);

    await waylandLayerShellPlugin.initialize(data.panelWidth, data.panelHeight);
    await waylandLayerShellPlugin.setAnchor(data.anchor, true);
    await waylandLayerShellPlugin.setLayer(data.layer);
    // await waylandLayerShellPlugin.setExclusiveZone(data.panelHeight);
    await waylandLayerShellPlugin.enableAutoExclusiveZone();

    return data;
  }

  Future<void> applySettings() async {
    final waylandLayerShellPlugin = WaylandLayerShell();
    await waylandLayerShellPlugin.initialize(state.value?.panelWidth ?? 1366, state.value?.panelHeight ?? 768);
    await waylandLayerShellPlugin.setAnchor(state.value?.anchor ?? ShellEdge.edgeBottom, true);
    await waylandLayerShellPlugin.setLayer(state.value?.layer ?? ShellLayer.layerTop);
  }

  Future<void> setHeightNormal() async {
    final waylandLayerShellPlugin = WaylandLayerShell();
    await waylandLayerShellPlugin.initialize(state.value?.panelWidth ?? 1366, state.value!.panelHeight);
  }

  Future<void> setHeightExpanded() async {
    final waylandLayerShellPlugin = WaylandLayerShell();
    await waylandLayerShellPlugin.initialize(state.value?.panelWidth ?? 1366, state.value!.panelHeight * 8);
  }

  Future<void> setPanelWidth(int width) async {
    final data = state.value?.copyWith(panelWidth: width);
    state = AsyncData(data!);
  }

  Future<void> setPanelHeight(int height) async {
    final data = state.value?.copyWith(panelHeight: height);
    state = AsyncData(data!);
  }

  Future<void> setAnchor(ShellEdge anchor) async {
    final data = state.value?.copyWith(anchor: anchor);
    state = AsyncData(data!);
  }

  Future<void> setLayer(ShellLayer layer) async {
    final data = state.value?.copyWith(layer: layer);
    state = AsyncData(data!);
  }
}
