import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:crypto/crypto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kitshell/data/model/hive/appinfo_metadata.dart';
import 'package:kitshell/data/model/runtime/appinfo/appinfo_model.dart';
import 'package:kitshell/data/repository/appmenu/app_metadata_repo.dart';
import 'package:kitshell/etc/utitity/logger.dart';
import 'package:kitshell/src/rust/api/appmenu/appmenu_items.dart';

part 'appmenu_event.dart';
part 'appmenu_state.dart';
part 'appmenu_bloc.freezed.dart';

@singleton
class AppmenuBloc extends Bloc<AppmenuEvent, AppmenuState> {
  AppmenuBloc({
    required AppMetadataRepo appIconCacheRepo,
  }) : _appMetadataRepo = appIconCacheRepo,
       super(const AppmenuInitial()) {
    on<AppmenuLoad>(_load, transformer: droppable());
    // on<AppmenuSearched>();
    // on<AppmenuAppExecuted>();
  }

  final AppMetadataRepo _appMetadataRepo;

  Future<void> _load(AppmenuLoad event, Emitter<AppmenuState> emit) async {
    if (state is AppmenuInitial) {
      await _appMetadataRepo.initDb();
    }

    logger.i('AppmenuBloc: Start loading apps');
    final result = [...await getAppmenuItems(locale: event.locale)];

    // Populate result with icon taken from cache (if theres any)
    // Otherwise, find icon
    logger.i('AppmenuBloc: Apps loaded, populating apps with metadata');
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
    logger.i('AppmenuBloc: Metadata loaded');
    emit(AppmenuLoaded(entries: completeApps));
  }
}
