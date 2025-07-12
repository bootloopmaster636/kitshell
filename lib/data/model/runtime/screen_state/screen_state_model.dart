import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kitshell/etc/panel_enum.dart';

part 'screen_state_model.freezed.dart';
part 'screen_state_model.g.dart';

@freezed
sealed class ScreenStateModel with _$ScreenStateModel {
  const factory ScreenStateModel({
    required bool isPopupShown,
    PopupWidget? popupShown,
  }) = _ScreenStateModel;

  factory ScreenStateModel.fromJson(Map<String, dynamic> json) =>
      _$ScreenStateModelFromJson(json);
}
