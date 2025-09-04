import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kitshell/data/model/runtime/appinfo/appinfo_model.dart';
import 'package:kitshell/data/repository/appmenu/app_metadata_repo.dart';
import 'package:kitshell/etc/utitity/logger.dart';
import 'package:kitshell/src/rust/api/appmenu/appmenu_items.dart';

part 'appmenu_bloc.freezed.dart';
part 'appmenu_event.dart';
part 'appmenu_state.dart';

@singleton
class AppmenuBloc extends Bloc<AppmenuEvent, AppmenuState> {
  AppmenuBloc({
    required AppMetadataRepo appIconCacheRepo,
  }) : _appMetadataRepo = appIconCacheRepo,
       super(const AppmenuInitial()) {
    on<AppmenuLoad>(_load, transformer: droppable());
    on<AppmenuPinToggled>(_togglePin);
    on<AppmenuRankReset>(_resetRank);
    on<AppmenuAppExecuted>(_open);
    // on<AppmenuSearched>();
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

    // Sort by alphabet
    completeApps.sort(
      (a, b) => a.entry.name.compareTo(b.entry.name),
    );

    // Separate between pinned and not pinned entry
    final regularEntry = <AppInfoModel>[];
    final pinnedEntry = <AppInfoModel>[];
    for (final app in completeApps) {
      if (app.metadata.isPinned) {
        pinnedEntry.add(app);
      } else {
        regularEntry.add(app);
      }
    }

    emit(
      AppmenuLoaded(
        entries: regularEntry,
        pinnedEntries: pinnedEntry,
        locale: event.locale,
      ),
    );
  }

  Future<void> _open(
    AppmenuAppExecuted event,
    Emitter<AppmenuState> emit,
  ) async {
    await _appMetadataRepo.incrementRank(event.appId);
    await launchApp(exec: event.exec, useTerminal: event.runInTerminal);
  }

  Future<void> _togglePin(
    AppmenuPinToggled event,
    Emitter<AppmenuState> emit,
  ) async {
    if (state is! AppmenuLoaded) return;
    await _appMetadataRepo.togglePin(event.id);
    add(AppmenuLoad((state as AppmenuLoaded).locale));
  }

  Future<void> _resetRank(
    AppmenuRankReset event,
    Emitter<AppmenuState> emit,
  ) async {
    if (state is! AppmenuLoaded) return;
    await _appMetadataRepo.resetRank(event.id);
    add(AppmenuLoad((state as AppmenuLoaded).locale));
  }
}
