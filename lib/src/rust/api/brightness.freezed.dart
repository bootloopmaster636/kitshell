// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brightness.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BrightnessData {
  List<String> get device => throw _privateConstructorUsedError;
  Uint32List get brightness => throw _privateConstructorUsedError;

  /// Create a copy of BrightnessData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BrightnessDataCopyWith<BrightnessData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BrightnessDataCopyWith<$Res> {
  factory $BrightnessDataCopyWith(
          BrightnessData value, $Res Function(BrightnessData) then) =
      _$BrightnessDataCopyWithImpl<$Res, BrightnessData>;
  @useResult
  $Res call({List<String> device, Uint32List brightness});
}

/// @nodoc
class _$BrightnessDataCopyWithImpl<$Res, $Val extends BrightnessData>
    implements $BrightnessDataCopyWith<$Res> {
  _$BrightnessDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BrightnessData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? device = null,
    Object? brightness = null,
  }) {
    return _then(_value.copyWith(
      device: null == device
          ? _value.device
          : device // ignore: cast_nullable_to_non_nullable
              as List<String>,
      brightness: null == brightness
          ? _value.brightness
          : brightness // ignore: cast_nullable_to_non_nullable
              as Uint32List,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BrightnessDataImplCopyWith<$Res>
    implements $BrightnessDataCopyWith<$Res> {
  factory _$$BrightnessDataImplCopyWith(_$BrightnessDataImpl value,
          $Res Function(_$BrightnessDataImpl) then) =
      __$$BrightnessDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> device, Uint32List brightness});
}

/// @nodoc
class __$$BrightnessDataImplCopyWithImpl<$Res>
    extends _$BrightnessDataCopyWithImpl<$Res, _$BrightnessDataImpl>
    implements _$$BrightnessDataImplCopyWith<$Res> {
  __$$BrightnessDataImplCopyWithImpl(
      _$BrightnessDataImpl _value, $Res Function(_$BrightnessDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of BrightnessData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? device = null,
    Object? brightness = null,
  }) {
    return _then(_$BrightnessDataImpl(
      device: null == device
          ? _value._device
          : device // ignore: cast_nullable_to_non_nullable
              as List<String>,
      brightness: null == brightness
          ? _value.brightness
          : brightness // ignore: cast_nullable_to_non_nullable
              as Uint32List,
    ));
  }
}

/// @nodoc

class _$BrightnessDataImpl extends _BrightnessData {
  const _$BrightnessDataImpl(
      {required final List<String> device, required this.brightness})
      : _device = device,
        super._();

  final List<String> _device;
  @override
  List<String> get device {
    if (_device is EqualUnmodifiableListView) return _device;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_device);
  }

  @override
  final Uint32List brightness;

  @override
  String toString() {
    return 'BrightnessData(device: $device, brightness: $brightness)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BrightnessDataImpl &&
            const DeepCollectionEquality().equals(other._device, _device) &&
            const DeepCollectionEquality()
                .equals(other.brightness, brightness));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_device),
      const DeepCollectionEquality().hash(brightness));

  /// Create a copy of BrightnessData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BrightnessDataImplCopyWith<_$BrightnessDataImpl> get copyWith =>
      __$$BrightnessDataImplCopyWithImpl<_$BrightnessDataImpl>(
          this, _$identity);
}

abstract class _BrightnessData extends BrightnessData {
  const factory _BrightnessData(
      {required final List<String> device,
      required final Uint32List brightness}) = _$BrightnessDataImpl;
  const _BrightnessData._() : super._();

  @override
  List<String> get device;
  @override
  Uint32List get brightness;

  /// Create a copy of BrightnessData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BrightnessDataImplCopyWith<_$BrightnessDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
