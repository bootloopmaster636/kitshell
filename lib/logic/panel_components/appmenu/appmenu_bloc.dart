import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kitshell/data/model/runtime/appinfo/appinfo_model.dart';
import 'package:kitshell/data/repository/appmenu/app_list_repo.dart';
import 'package:kitshell/data/repository/appmenu/app_metadata_repo.dart';
import 'package:kitshell/etc/utitity/bloc_transformer.dart';
import 'package:kitshell/etc/utitity/config.dart';
import 'package:kitshell/etc/utitity/logger.dart';
import 'package:kitshell/src/rust/api/appmenu/appmenu_items.dart';
import 'package:rapidfuzz/rapidfuzz.dart';

part 'appmenu_bloc.freezed.dart';
part 'appmenu_event.dart';
part 'appmenu_state.dart';

@singleton
class AppmenuBloc extends Bloc<AppmenuEvent, AppmenuState> {
  AppmenuBloc({
    required AppListRepo appListRepo,
    required AppMetadataRepo appMetadataRepo,
  }) : _appListRepo = appListRepo,
       _appMetadataRepo = appMetadataRepo,
       super(const AppmenuInitial()) {
    on<AppmenuSubscribed>(_subs, transformer: droppable());
    on<AppmenuLoad>(_load, transformer: droppable());
    on<AppmenuPinToggled>(_togglePin);
    on<AppmenuRankReset>(_resetRank);
    on<AppmenuAppExecuted>(_open, transformer: droppable());
    on<AppmenuSearched>(
      _search,
      transformer: debounced(const Duration(milliseconds: 250)),
    );
  }

  final AppMetadataRepo _appMetadataRepo;
  final AppListRepo _appListRepo;

  Future<void> _subs(
    AppmenuSubscribed event,
    Emitter<AppmenuState> emit,
  ) async {
    return emit.forEach(
      _appListRepo.appsList,
      onData: (apps) {
        // Sort by alphabet
        final completeApps = <AppInfoModel>[...apps]
          ..sort(
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

        return AppmenuLoaded(
          entries: regularEntry,
          pinnedEntries: pinnedEntry,
        );
      },
    );
  }

  Future<void> _load(AppmenuLoad event, Emitter<AppmenuState> emit) async {
    // TODO(bootloopmaster636): Use dynamic locale from front end
    _appListRepo.locale = event.locale ?? 'en_US';
    await _appListRepo.load();
  }

  Future<void> _open(
    AppmenuAppExecuted event,
    Emitter<AppmenuState> emit,
  ) async {
    await _appMetadataRepo.incrementRank(event.app.entry.id);
    await launchApp(
      exec: event.app.entry.exec,
      useTerminal: event.app.entry.runInTerminal,
    );
  }

  Future<void> _togglePin(
    AppmenuPinToggled event,
    Emitter<AppmenuState> emit,
  ) async {
    if (state is! AppmenuLoaded) return;
    await _appMetadataRepo.togglePin(event.id);
    add(const AppmenuLoad());
  }

  Future<void> _resetRank(
    AppmenuRankReset event,
    Emitter<AppmenuState> emit,
  ) async {
    if (state is! AppmenuLoaded) return;
    await _appMetadataRepo.resetRank(event.id);
    add(const AppmenuLoad());
  }

  Future<void> _search(
    AppmenuSearched event,
    Emitter<AppmenuState> emit,
  ) async {
    if (state is! AppmenuLoaded) return;
    final loadedState = state as AppmenuLoaded;

    // Early return if no query
    if (event.query.isEmpty) {
      logger.i('AppmenuBloc: No search query');
      emit(
        loadedState.copyWith(
          searchQuery: '',
          searchResult: null,
        ),
      );
      return;
    }

    final searchResult = <(AppInfoModel, double)>[];

    // Filter apps
    for (final e in loadedState.pinnedEntries) {
      final ratio = tokenSortPartialRatio(
        event.query.toLowerCase(),
        '${e.entry.name.toLowerCase()} ${e.entry.desc.toLowerCase()} ${e.entry.exec}',
      );
      if (ratio > fuzzySearchThreshold) {
        searchResult.add((e, ratio));
      }
    }

    for (final e in loadedState.entries) {
      final ratio = tokenSortPartialRatio(
        event.query.toLowerCase(),
        '${e.entry.name.toLowerCase()} ${e.entry.desc.toLowerCase()} ${e.entry.exec}',
      );
      if (ratio > fuzzySearchThreshold) {
        searchResult.add((e, ratio));
      }
    }

    // Sort the list by ratio and times opened
    searchResult
      ..sort(
        (a, b) =>
            b.$1.metadata.timesLaunched.compareTo(a.$1.metadata.timesLaunched),
      )
      ..sort((a, b) => a.$2.compareTo(b.$2));

    logger.i(
      'AppmenuBloc: Searched for ${event.query}, found ${searchResult.length} apps',
    );
    emit(
      loadedState.copyWith(
        searchQuery: event.query,
        searchResult: searchResult.map((e) => e.$1).toList(),
      ),
    );
  }
}
