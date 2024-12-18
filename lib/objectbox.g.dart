// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again
// with `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types, depend_on_referenced_packages
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'
    as obx_int; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart' as obx;
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'settings/persistence/appmenu_model.dart';
import 'settings/persistence/layer_shell_model.dart';
import 'settings/persistence/look_and_feel_model.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <obx_int.ModelEntity>[
  obx_int.ModelEntity(
      id: const obx_int.IdUid(1, 1263182219572807415),
      name: 'LayerShellDb',
      lastPropertyId: const obx_int.IdUid(7, 4255286580257234853),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 8366536221261636654),
            name: 'id',
            type: 6,
            flags: 129),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 7616755413779612559),
            name: 'panelWidth',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 3415541208451183539),
            name: 'panelHeight',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 789773468822869044),
            name: 'anchor',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 2025958618046492694),
            name: 'layer',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(6, 2104884751753657870),
            name: 'autoExclusiveZone',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(7, 4255286580257234853),
            name: 'monitor',
            type: 6,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(2, 6698587999003702616),
      name: 'LookAndFeelDb',
      lastPropertyId: const obx_int.IdUid(3, 5025405412599255850),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 8777950951146970592),
            name: 'id',
            type: 6,
            flags: 129),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 6331721569767958672),
            name: 'themeMode',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 5025405412599255850),
            name: 'color',
            type: 6,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(5, 3721725433225428347),
      name: 'AppmenuDb',
      lastPropertyId: const obx_int.IdUid(8, 7129089741573961930),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 1537545341898657317),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 1972158982413954288),
            name: 'name',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 5277156860968912086),
            name: 'description',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 3040759591975715816),
            name: 'exec',
            type: 30,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 8127975776249308838),
            name: 'icon',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(6, 3430801084411939998),
            name: 'useTerminal',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(7, 3697322225586413469),
            name: 'isFavorite',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(8, 7129089741573961930),
            name: 'frequency',
            type: 6,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[])
];

/// Shortcut for [obx.Store.new] that passes [getObjectBoxModel] and for Flutter
/// apps by default a [directory] using `defaultStoreDirectory()` from the
/// ObjectBox Flutter library.
///
/// Note: for desktop apps it is recommended to specify a unique [directory].
///
/// See [obx.Store.new] for an explanation of all parameters.
///
/// For Flutter apps, also calls `loadObjectBoxLibraryAndroidCompat()` from
/// the ObjectBox Flutter library to fix loading the native ObjectBox library
/// on Android 6 and older.
Future<obx.Store> openStore(
    {String? directory,
    int? maxDBSizeInKB,
    int? maxDataSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool queriesCaseSensitiveDefault = true,
    String? macosApplicationGroup}) async {
  await loadObjectBoxLibraryAndroidCompat();
  return obx.Store(getObjectBoxModel(),
      directory: directory ?? (await defaultStoreDirectory()).path,
      maxDBSizeInKB: maxDBSizeInKB,
      maxDataSizeInKB: maxDataSizeInKB,
      fileMode: fileMode,
      maxReaders: maxReaders,
      queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
      macosApplicationGroup: macosApplicationGroup);
}

/// Returns the ObjectBox model definition for this project for use with
/// [obx.Store.new].
obx_int.ModelDefinition getObjectBoxModel() {
  final model = obx_int.ModelInfo(
      entities: _entities,
      lastEntityId: const obx_int.IdUid(5, 3721725433225428347),
      lastIndexId: const obx_int.IdUid(0, 0),
      lastRelationId: const obx_int.IdUid(0, 0),
      lastSequenceId: const obx_int.IdUid(0, 0),
      retiredEntityUids: const [4569210074074232104, 4447290761756685390],
      retiredIndexUids: const [],
      retiredPropertyUids: const [
        1329298343516116,
        4603414675459261097,
        248660992109610847,
        2828949804232505180,
        5767165134830188555,
        7816627468165187452,
        8609341211948754274,
        4147787053919600039,
        3575341091933666942,
        8647460366945468672,
        2726593718133641249,
        8900707085188590110,
        2208817589955831269,
        2567550078641403876,
        5563011487634726737,
        6569061894873464514
      ],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, obx_int.EntityDefinition>{
    LayerShellDb: obx_int.EntityDefinition<LayerShellDb>(
        model: _entities[0],
        toOneRelations: (LayerShellDb object) => [],
        toManyRelations: (LayerShellDb object) => {},
        getId: (LayerShellDb object) => object.id,
        setId: (LayerShellDb object, int id) {
          object.id = id;
        },
        objectToFB: (LayerShellDb object, fb.Builder fbb) {
          final anchorOffset = fbb.writeString(object.anchor);
          final layerOffset = fbb.writeString(object.layer);
          fbb.startTable(8);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.panelWidth);
          fbb.addInt64(2, object.panelHeight);
          fbb.addOffset(3, anchorOffset);
          fbb.addOffset(4, layerOffset);
          fbb.addBool(5, object.autoExclusiveZone);
          fbb.addInt64(6, object.monitor);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = LayerShellDb()
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..panelWidth =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0)
            ..panelHeight =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0)
            ..anchor = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 10, '')
            ..layer = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 12, '')
            ..autoExclusiveZone =
                const fb.BoolReader().vTableGet(buffer, rootOffset, 14, false)
            ..monitor = const fb.Int64Reader()
                .vTableGetNullable(buffer, rootOffset, 16);

          return object;
        }),
    LookAndFeelDb: obx_int.EntityDefinition<LookAndFeelDb>(
        model: _entities[1],
        toOneRelations: (LookAndFeelDb object) => [],
        toManyRelations: (LookAndFeelDb object) => {},
        getId: (LookAndFeelDb object) => object.id,
        setId: (LookAndFeelDb object, int id) {
          object.id = id;
        },
        objectToFB: (LookAndFeelDb object, fb.Builder fbb) {
          final themeModeOffset = fbb.writeString(object.themeMode);
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, themeModeOffset);
          fbb.addInt64(2, object.color);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = LookAndFeelDb()
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..themeMode = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 6, '')
            ..color =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0);

          return object;
        }),
    AppmenuDb: obx_int.EntityDefinition<AppmenuDb>(
        model: _entities[2],
        toOneRelations: (AppmenuDb object) => [],
        toManyRelations: (AppmenuDb object) => {},
        getId: (AppmenuDb object) => object.id,
        setId: (AppmenuDb object, int id) {
          object.id = id;
        },
        objectToFB: (AppmenuDb object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final descriptionOffset = fbb.writeString(object.description);
          final execOffset = fbb.writeList(
              object.exec.map(fbb.writeString).toList(growable: false));
          final iconOffset = fbb.writeString(object.icon);
          fbb.startTable(9);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addOffset(2, descriptionOffset);
          fbb.addOffset(3, execOffset);
          fbb.addOffset(4, iconOffset);
          fbb.addBool(5, object.useTerminal);
          fbb.addBool(6, object.isFavorite);
          fbb.addInt64(7, object.frequency);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = AppmenuDb()
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..name = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 6, '')
            ..description = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 8, '')
            ..exec = const fb.ListReader<String>(
                    fb.StringReader(asciiOptimization: true),
                    lazy: false)
                .vTableGet(buffer, rootOffset, 10, [])
            ..icon = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 12, '')
            ..useTerminal =
                const fb.BoolReader().vTableGet(buffer, rootOffset, 14, false)
            ..isFavorite =
                const fb.BoolReader().vTableGet(buffer, rootOffset, 16, false)
            ..frequency =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 18, 0);

          return object;
        })
  };

  return obx_int.ModelDefinition(model, bindings);
}

/// [LayerShellDb] entity fields to define ObjectBox queries.
class LayerShellDb_ {
  /// See [LayerShellDb.id].
  static final id =
      obx.QueryIntegerProperty<LayerShellDb>(_entities[0].properties[0]);

  /// See [LayerShellDb.panelWidth].
  static final panelWidth =
      obx.QueryIntegerProperty<LayerShellDb>(_entities[0].properties[1]);

  /// See [LayerShellDb.panelHeight].
  static final panelHeight =
      obx.QueryIntegerProperty<LayerShellDb>(_entities[0].properties[2]);

  /// See [LayerShellDb.anchor].
  static final anchor =
      obx.QueryStringProperty<LayerShellDb>(_entities[0].properties[3]);

  /// See [LayerShellDb.layer].
  static final layer =
      obx.QueryStringProperty<LayerShellDb>(_entities[0].properties[4]);

  /// See [LayerShellDb.autoExclusiveZone].
  static final autoExclusiveZone =
      obx.QueryBooleanProperty<LayerShellDb>(_entities[0].properties[5]);

  /// See [LayerShellDb.monitor].
  static final monitor =
      obx.QueryIntegerProperty<LayerShellDb>(_entities[0].properties[6]);
}

/// [LookAndFeelDb] entity fields to define ObjectBox queries.
class LookAndFeelDb_ {
  /// See [LookAndFeelDb.id].
  static final id =
      obx.QueryIntegerProperty<LookAndFeelDb>(_entities[1].properties[0]);

  /// See [LookAndFeelDb.themeMode].
  static final themeMode =
      obx.QueryStringProperty<LookAndFeelDb>(_entities[1].properties[1]);

  /// See [LookAndFeelDb.color].
  static final color =
      obx.QueryIntegerProperty<LookAndFeelDb>(_entities[1].properties[2]);
}

/// [AppmenuDb] entity fields to define ObjectBox queries.
class AppmenuDb_ {
  /// See [AppmenuDb.id].
  static final id =
      obx.QueryIntegerProperty<AppmenuDb>(_entities[2].properties[0]);

  /// See [AppmenuDb.name].
  static final name =
      obx.QueryStringProperty<AppmenuDb>(_entities[2].properties[1]);

  /// See [AppmenuDb.description].
  static final description =
      obx.QueryStringProperty<AppmenuDb>(_entities[2].properties[2]);

  /// See [AppmenuDb.exec].
  static final exec =
      obx.QueryStringVectorProperty<AppmenuDb>(_entities[2].properties[3]);

  /// See [AppmenuDb.icon].
  static final icon =
      obx.QueryStringProperty<AppmenuDb>(_entities[2].properties[4]);

  /// See [AppmenuDb.useTerminal].
  static final useTerminal =
      obx.QueryBooleanProperty<AppmenuDb>(_entities[2].properties[5]);

  /// See [AppmenuDb.isFavorite].
  static final isFavorite =
      obx.QueryBooleanProperty<AppmenuDb>(_entities[2].properties[6]);

  /// See [AppmenuDb.frequency].
  static final frequency =
      obx.QueryIntegerProperty<AppmenuDb>(_entities[2].properties[7]);
}
