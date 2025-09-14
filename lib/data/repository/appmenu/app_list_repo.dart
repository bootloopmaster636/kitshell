import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:kitshell/data/model/runtime/appinfo/appinfo_model.dart';
import 'package:kitshell/data/repository/appmenu/app_metadata_repo.dart';
import 'package:kitshell/etc/utitity/logger.dart';
import 'package:kitshell/src/rust/api/appmenu/appmenu_items.dart';

@singleton
class AppListRepo {
  AppListRepo({required AppMetadataRepo appMetadataRepo})
    : _appMetadataRepo = appMetadataRepo,
      _controller = StreamController<List<AppInfoModel>>(),
      locale = 'en_US';

  /// Current app list locale, this is used when loading apps
  String locale;

  final StreamController<List<AppInfoModel>> _controller;

  /// Stream of app list that can be listened
  Stream<List<AppInfoModel>> get appsList async* {
    yield* _controller.stream.asBroadcastStream();
  }

  /// Current state of app list. non reactive and must be called.
  /// If you want the reactive version. use [appsList] instead.
  List<AppInfoModel> get current => _currentPrivate;

  List<AppInfoModel> _currentPrivate = [];

  // Since dart does not support private setter, we must use this trick
  // ignore: use_setters_to_change_properties
  void _setCurrentPrivate(List<AppInfoModel> val) => _currentPrivate = val;

  final AppMetadataRepo _appMetadataRepo;

  Future<void> load() async {
    await _appMetadataRepo.initDb();

    logger.i('AppListRepo: Start loading apps');
    final result = [...await getAppmenuItems(locale: locale)];

    // Populate result with icon taken from cache (if theres any)
    // Otherwise, find icon
    logger.i('AppListRepo: Apps loaded, populating apps with metadata');
    final completeApps = <AppInfoModel>[];
    for (final app in result) {
      var appMetadata = await _appMetadataRepo.searchById(app.id);

      // Get icon and new metadata if metadata not found.
      if (appMetadata == null) {
        final iconPath = await getIconPath(icon: app.icon);
        appMetadata = await _appMetadataRepo.addNew(
          id: app.id,
          iconPath: iconPath,
        );
      }

      completeApps.add(AppInfoModel(entry: app, metadata: appMetadata));
    }
    logger.i('AppListRepo: Metadata loaded');

    _controller.add(completeApps);
    _setCurrentPrivate(completeApps);
  }
}
