import 'package:kitshell/main.dart';
import 'package:kitshell/settings/logic/layer_shell/layer_shell.dart';
import 'package:objectbox/objectbox.dart';
import 'package:wayland_layer_shell/types.dart';

@Entity()
class LayerShellDb {
  @Id(assignable: true)
  late int id;
  late int panelWidth;
  late int panelHeight;
  late String anchor;
  late String layer;
  late bool autoExclusiveZone;
  late int? monitor;
}

void storeLayerShellSettings(LayerShellData newSettings) {
  final layerShellBox = objectbox.store.box<LayerShellDb>();

  final anchorConverted = newSettings.anchor.toString();
  final layerConverted = newSettings.layer.toString();

  final object = LayerShellDb()
    ..id = 1
    ..panelWidth = newSettings.panelWidth
    ..panelHeight = newSettings.panelHeight
    ..anchor = anchorConverted
    ..layer = layerConverted
    ..autoExclusiveZone = newSettings.autoExclusiveZone
    ..monitor = newSettings.monitor?.id;

  layerShellBox.put(object);
}

LayerShellData getLayerShellSettings() {
  final layerShellBox = objectbox.store.box<LayerShellDb>();
  final object = layerShellBox.get(1);

  final anchorConverted =
      object != null ? ShellEdge.values.firstWhere((e) => e.toString() == object?.anchor) : ShellEdge.edgeBottom;
  final layerConverted =
      object != null ? ShellLayer.values.firstWhere((e) => e.toString() == object?.layer) : ShellLayer.layerTop;
  final monitorConverted = object?.monitor != null ? Monitor(object!.monitor ?? 0, '') : null;

  return LayerShellData(
    panelWidth: object?.panelWidth ?? 1366,
    panelHeight: object?.panelHeight ?? 48,
    anchor: anchorConverted,
    layer: layerConverted,
    autoExclusiveZone: object?.autoExclusiveZone ?? true,
    monitor: monitorConverted,
  );
}
