import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:kitshell/data/model/hive/appinfo_metadata.dart';
import 'package:kitshell/etc/utitity/logger.dart';

@singleton
class AppMetadataRepo {
  late final Box<dynamic> _box;

  Future<void> initDb() async {
    _box = await Hive.openBox('appMetadata');
  }

  Future<AppEntryMetadata> addNew({
    required String id,
    required String iconPath,
  }) async {
    final newMetadata = AppEntryMetadata(
      iconPath: iconPath,
      isPinned: false,
      timesLaunched: 0,
    );
    await _box.put(id, newMetadata);
    return newMetadata;
  }

  Future<AppEntryMetadata?> searchById(String id) async {
    return _box.get(id) as AppEntryMetadata?;
  }

  Future<void> togglePin(String id) async {
    final app = _box.get(id) as AppEntryMetadata?;
    if (app == null) return;
    app.isPinned = !app.isPinned;
    await _box.put(id, app);
    logger.i(
      'AppMetadataRepo: Toggling favorite on app $id, isPinned? ${app.isPinned}',
    );
  }

  Future<void> incrementRank(String id) async {
    final app = _box.get(id) as AppEntryMetadata?;
    if (app == null) return;
    app.timesLaunched += 1;
    await _box.put(id, app);
  }

  Future<void> resetRank(String id) async {
    final app = _box.get(id) as AppEntryMetadata?;
    if (app == null) return;
    app.timesLaunched = 0;
    await _box.put(id, app);
  }

  Future<void> cleanUp() async {}
}
