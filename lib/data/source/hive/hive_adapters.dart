import 'package:hive_ce/hive.dart';
import 'package:kitshell/data/model/hive/appinfo_metadata.dart';
import 'package:kitshell/data/model/hive/launchbar_items.dart';

@GenerateAdapters([
  AdapterSpec<AppEntryMetadata>(),
  AdapterSpec<LaunchbarItem>(),
])
part 'hive_adapters.g.dart';
