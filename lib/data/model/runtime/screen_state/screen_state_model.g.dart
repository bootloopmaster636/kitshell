// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screen_state_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScreenStateModel _$ScreenStateModelFromJson(Map<String, dynamic> json) =>
    _ScreenStateModel(
      isPopupShown: json['isPopupShown'] as bool,
      popupShown: $enumDecodeNullable(_$PopupWidgetEnumMap, json['popupShown']),
    );

Map<String, dynamic> _$ScreenStateModelToJson(_ScreenStateModel instance) =>
    <String, dynamic>{
      'isPopupShown': instance.isPopupShown,
      'popupShown': _$PopupWidgetEnumMap[instance.popupShown],
    };

const _$PopupWidgetEnumMap = {
  PopupWidget.appMenu: 'appMenu',
  PopupWidget.calendar: 'calendar',
  PopupWidget.quickSettings: 'quickSettings',
};
