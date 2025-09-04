import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kitshell/data/model/hive/appinfo_metadata.dart';
import 'package:kitshell/src/rust/api/appmenu/appmenu_items.dart';

part 'appinfo_model.freezed.dart';

@freezed
sealed class AppInfoModel with _$AppInfoModel {
  const factory AppInfoModel({
    required AppEntry entry,
    required AppEntryMetadata metadata,
  }) = _AppInfoModel;
}
