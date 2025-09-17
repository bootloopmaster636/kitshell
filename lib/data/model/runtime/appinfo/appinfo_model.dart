import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kitshell/data/model/hive/appinfo_metadata.dart';
import 'package:kitshell/src/rust/api/appmenu/appmenu_items.dart';
import 'package:kitshell/src/rust/api/wm_interface/base.dart';

part 'appinfo_model.freezed.dart';

@freezed
sealed class AppInfoModel with _$AppInfoModel {
  const factory AppInfoModel({
    required AppEntry entry,
    required AppEntryMetadata metadata,
  }) = _AppInfoModel;
}

@freezed
sealed class LaunchbarItem with _$LaunchbarItem {
  const factory LaunchbarItem({
    /// Whether this app is pinned to launchbar
    required bool isPinned,

    /// Info regarding app and desktop entry.
    /// Available when not running, might be available when running (depending
    /// whether we got the right info or not)
    AppInfoModel? appInfo,

    /// Info regarding running app.
    /// It is null when this app is not running.
    LaunchbarItemState? windowInfo,
  }) = _LaunchbarItem;
}
