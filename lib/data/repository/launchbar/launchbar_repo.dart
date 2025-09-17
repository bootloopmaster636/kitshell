import 'dart:async';

import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:kitshell/data/model/hive/launchbar_items.dart';
import 'package:kitshell/data/model/runtime/appinfo/appinfo_model.dart';
import 'package:kitshell/data/repository/appmenu/app_list_repo.dart';
import 'package:kitshell/etc/utitity/logger.dart';
import 'package:rxdart/rxdart.dart';

@singleton
class LaunchbarRepo {
  LaunchbarRepo({required AppListRepo appListRepo})
    : _pinnedAppsController = StreamController<List<AppInfoModel>>(),
      _appListRepo = appListRepo;

  late final Box<dynamic> _box;

  final AppListRepo _appListRepo;
  final StreamController<List<AppInfoModel>> _pinnedAppsController;
  late StreamSubscription<BoxEvent> _appListStream;

  Stream<List<AppInfoModel>> get pinnedAppsList {
    return _pinnedAppsController.stream
        .debounceTime(const Duration(milliseconds: 20))
        .asBroadcastStream();
  }

  Future<void> initDb() async {
    _box = await Hive.openBox('launchbar');
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  Future<void> startWatchingAppList() async {
    List<AppInfoModel> fromDbToApplist(
      List<LaunchbarItemPersist> launchbarItem,
    ) {
      final appList = _appListRepo.current;
      final result = <AppInfoModel>[];

      // Sort launchbar item by index
      launchbarItem.sort((a, b) => a.idx.compareTo(b.idx));

      // Complete with app info
      for (final item in launchbarItem) {
        final appInfo = appList.where(
          (e) => e.entry.id == item.appId,
        );

        if (appInfo.isEmpty) continue;

        result.add(appInfo.first);
      }

      return result;
    }

    // Initialize with current app list
    _pinnedAppsController.add(
      fromDbToApplist(
        _box.values.map((e) => e as LaunchbarItemPersist).toList(),
      ),
    );

    // Add to stream on subsequent db event
    logger.i('LaunchbarRepo: Listening for changes in app list');
    _appListStream = _box.watch().listen((_) {
      _pinnedAppsController.add(
        fromDbToApplist(
          _box.values.map((e) => e as LaunchbarItemPersist).toList(),
        ),
      );
    });
  }

  Future<void> addNew(String appId) async {
    // Always add the new item after the last element in launchbar
    final length = _box.values.length;
    await _box.put(appId, LaunchbarItemPersist(appId: appId, idx: length));
  }

  Future<void> changeIndex({
    required String appHash,
    required int newIdx,
  }) async {
    final item = _box.get(appHash) as LaunchbarItemPersist?;
    if (item == null) return;
    item.idx = newIdx;
    await _box.put(appHash, item);
  }

  Future<void> removeItem(String appId) async {
    await _box.delete(appId);
  }

  Future<void> dispose() async {
    await _appListStream.cancel();
    await _pinnedAppsController.close();
  }
}
