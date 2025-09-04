part of 'appmenu_bloc.dart';

@freezed
class AppmenuState with _$AppmenuState {
  const factory AppmenuState.initial() = AppmenuInitial;
  const factory AppmenuState.loaded({
    required List<AppInfoModel> entries,
    String? searchQuery,
    List<AppEntry>? searchResult,
  }) = AppmenuLoaded;
}
