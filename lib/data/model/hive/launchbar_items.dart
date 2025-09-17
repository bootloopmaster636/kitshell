import 'package:hive_ce/hive.dart';

class LaunchbarItemPersist extends HiveObject {
  LaunchbarItemPersist({
    required this.appId,
    required this.idx,
  });

  String appId;
  int idx;
}
