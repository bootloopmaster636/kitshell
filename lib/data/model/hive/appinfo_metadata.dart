import 'package:hive_ce/hive.dart';

class AppEntryMetadata extends HiveObject {
  AppEntryMetadata({
    required this.iconPath,
    required this.isPinned,
    required this.timesLaunched,
  });

  String iconPath;
  bool isPinned;
  int timesLaunched;
}
