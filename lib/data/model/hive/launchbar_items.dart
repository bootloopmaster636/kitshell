import 'package:hive_ce/hive.dart';

class LaunchbarItem extends HiveObject {
  LaunchbarItem({
    required this.appId,
    required this.idx,
  });

  String appId;
  int idx;
}
