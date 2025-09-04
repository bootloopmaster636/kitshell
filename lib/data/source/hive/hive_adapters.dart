import 'package:hive_ce/hive.dart';
import 'package:kitshell/data/model/hive/appinfo_metadata.dart';

@GenerateAdapters([AdapterSpec<AppEntryMetadata>()])
part 'hive_adapters.g.dart';
