part of 'appmenu_bloc.dart';

@freezed
class AppmenuState with _$AppmenuState {
  const factory AppmenuState.initial() = AppmenuInitial;

  const factory AppmenuState.loaded({
    required List<AppInfoModel> entries,
    required List<AppInfoModel> pinnedEntries,
    required String locale,
    String? searchQuery,
    List<AppInfoModel>? searchResult,
  }) = AppmenuLoaded;
}
