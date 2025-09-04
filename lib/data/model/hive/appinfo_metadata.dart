import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';

@immutable
class AppEntryMetadata extends HiveObject {
  AppEntryMetadata({
    required this.iconPath,
    required this.isPinned,
    required this.timesLaunched,
  });

  String iconPath;
  bool isPinned;
  int timesLaunched;

  @override
  int get hashCode =>
      iconPath.hashCode ^ isPinned.hashCode ^ timesLaunched.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppEntryMetadata &&
          runtimeType == other.runtimeType &&
          iconPath == other.iconPath &&
          isPinned == other.isPinned &&
          timesLaunched == other.timesLaunched;
}
