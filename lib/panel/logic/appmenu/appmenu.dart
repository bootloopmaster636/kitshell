import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kitshell/settings/persistence/appmenu_model.dart';
import 'package:kitshell/src/rust/api/appmenu.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'appmenu.freezed.dart';

part 'appmenu.g.dart';

@freezed
class AppmenuInfo with _$AppmenuInfo {
  const factory AppmenuInfo({
    required int id,
    required String name,
    required List<String> exec,
    required String icon,
    required bool useTerminal,
    required bool isFavorite,
    required int frequency,
  }) = _AppmenuInfo;
}

@freezed
class AppmenuData with _$AppmenuData {
  const factory AppmenuData({
    required List<AppmenuInfo> appmenuNoFav,
    required List<AppmenuInfo> appmenuFav,
  }) = _AppmenuData;
}

@riverpod
class AppmenuLogic extends _$AppmenuLogic {
  @override
  Future<AppmenuData> build() async {
    state = const AsyncLoading();
    var dataNoFav = getAllAppsFromCache(isFavorite: false);
    var dataFav = getAllAppsFromCache(isFavorite: true);

    // when cache is empty, scan for apps and add to cache
    if (dataNoFav.isEmpty && dataFav.isEmpty) {
      final newData = await getAllApps();
      addToAppmenuDb(newData);
      dataNoFav = getAllAppsFromCache(isFavorite: false);
      dataFav = getAllAppsFromCache(isFavorite: true);
    }

    return AppmenuData(
      appmenuNoFav: dataNoFav,
      appmenuFav: dataFav,
    );
  }

  Future<void> refreshList({required bool deleteExisting, required bool rescanApps}) async {
    state = const AsyncLoading();

    if (deleteExisting) deleteAll();
    if (rescanApps) {
      final newData = await getAllApps();
      addToAppmenuDb(newData);
    }

    final dataNoFav = getAllAppsFromCache(isFavorite: false);
    final dataFav = getAllAppsFromCache(isFavorite: true);

    state = AsyncData(
      AppmenuData(
        appmenuNoFav: dataNoFav,
        appmenuFav: dataFav,
      ),
    );
  }
}
