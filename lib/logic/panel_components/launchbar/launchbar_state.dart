part of 'launchbar_bloc.dart';

@freezed
class LaunchbarState with _$LaunchbarState {
  const factory LaunchbarState.initial() = LaunchbarStateInitial;

  const factory LaunchbarState.loaded({
    required List<AppInfoModel> pinnedApps,
    required List<LaunchbarItemState> runningApps,
    required List<LaunchbarItem> items,
  }) = LaunchbarStateLoaded;
}
