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
mixin _$BrightnessInfo {
  int get brightness => throw _privateConstructorUsedError;
  int get maxBrightness => throw _privateConstructorUsedError;

  /// Create a copy of BrightnessInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BrightnessInfoCopyWith<BrightnessInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BrightnessInfoCopyWith<$Res> {
  factory $BrightnessInfoCopyWith(
          BrightnessInfo value, $Res Function(BrightnessInfo) then) =
      _$BrightnessInfoCopyWithImpl<$Res, BrightnessInfo>;
  @useResult
  $Res call({int brightness, int maxBrightness});
}

/// @nodoc
class _$BrightnessInfoCopyWithImpl<$Res, $Val extends BrightnessInfo>
    implements $BrightnessInfoCopyWith<$Res> {
  _$BrightnessInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BrightnessInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? brightness = null,
    Object? maxBrightness = null,
  }) {
    return _then(_value.copyWith(
      brightness: null == brightness
          ? _value.brightness
          : brightness // ignore: cast_nullable_to_non_nullable
              as int,
      maxBrightness: null == maxBrightness
          ? _value.maxBrightness
          : maxBrightness // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BrightnessInfoImplCopyWith<$Res>
    implements $BrightnessInfoCopyWith<$Res> {
  factory _$$BrightnessInfoImplCopyWith(_$BrightnessInfoImpl value,
          $Res Function(_$BrightnessInfoImpl) then) =
      __$$BrightnessInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int brightness, int maxBrightness});
}

/// @nodoc
class __$$BrightnessInfoImplCopyWithImpl<$Res>
    extends _$BrightnessInfoCopyWithImpl<$Res, _$BrightnessInfoImpl>
    implements _$$BrightnessInfoImplCopyWith<$Res> {
  __$$BrightnessInfoImplCopyWithImpl(
      _$BrightnessInfoImpl _value, $Res Function(_$BrightnessInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of BrightnessInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? brightness = null,
    Object? maxBrightness = null,
  }) {
    return _then(_$BrightnessInfoImpl(
      brightness: null == brightness
          ? _value.brightness
          : brightness // ignore: cast_nullable_to_non_nullable
              as int,
      maxBrightness: null == maxBrightness
          ? _value.maxBrightness
          : maxBrightness // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$BrightnessInfoImpl implements _BrightnessInfo {
  const _$BrightnessInfoImpl(
      {required this.brightness, required this.maxBrightness});

  @override
  final int brightness;
  @override
  final int maxBrightness;

  @override
  String toString() {
    return 'BrightnessInfo(brightness: $brightness, maxBrightness: $maxBrightness)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BrightnessInfoImpl &&
            (identical(other.brightness, brightness) ||
                other.brightness == brightness) &&
            (identical(other.maxBrightness, maxBrightness) ||
                other.maxBrightness == maxBrightness));
  }

  @override
  int get hashCode => Object.hash(runtimeType, brightness, maxBrightness);

  /// Create a copy of BrightnessInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BrightnessInfoImplCopyWith<_$BrightnessInfoImpl> get copyWith =>
      __$$BrightnessInfoImplCopyWithImpl<_$BrightnessInfoImpl>(
          this, _$identity);
}

abstract class _BrightnessInfo implements BrightnessInfo {
  const factory _BrightnessInfo(
      {required final int brightness,
      required final int maxBrightness}) = _$BrightnessInfoImpl;

  @override
  int get brightness;
  @override
  int get maxBrightness;

  /// Create a copy of BrightnessInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BrightnessInfoImplCopyWith<_$BrightnessInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
