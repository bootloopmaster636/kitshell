part of 'launchbar_bloc.dart';

@freezed
class LaunchbarEvent with _$LaunchbarEvent {
  /// Subscribes to pinned app list in launchbar
  const factory LaunchbarEvent.started() = LaunchbarEventStarted;

  /// Add app to the end of launchbar
  const factory LaunchbarEvent.add(String appId) = LaunchbarEventAdded;

  /// Swap entry position from x to y
  const factory LaunchbarEvent.swapPinned(int from, int to) =
      LaunchbarEventSwapPinned;
}
