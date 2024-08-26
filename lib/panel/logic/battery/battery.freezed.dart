// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'battery.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PowerProfilesInfo {
  PowerProfiles get profile => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PowerProfilesInfoCopyWith<PowerProfilesInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PowerProfilesInfoCopyWith<$Res> {
  factory $PowerProfilesInfoCopyWith(
          PowerProfilesInfo value, $Res Function(PowerProfilesInfo) then) =
      _$PowerProfilesInfoCopyWithImpl<$Res, PowerProfilesInfo>;
  @useResult
  $Res call({PowerProfiles profile});
}

/// @nodoc
class _$PowerProfilesInfoCopyWithImpl<$Res, $Val extends PowerProfilesInfo>
    implements $PowerProfilesInfoCopyWith<$Res> {
  _$PowerProfilesInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profile = null,
  }) {
    return _then(_value.copyWith(
      profile: null == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as PowerProfiles,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PowerProfilesInfoImplCopyWith<$Res>
    implements $PowerProfilesInfoCopyWith<$Res> {
  factory _$$PowerProfilesInfoImplCopyWith(_$PowerProfilesInfoImpl value,
          $Res Function(_$PowerProfilesInfoImpl) then) =
      __$$PowerProfilesInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({PowerProfiles profile});
}

/// @nodoc
class __$$PowerProfilesInfoImplCopyWithImpl<$Res>
    extends _$PowerProfilesInfoCopyWithImpl<$Res, _$PowerProfilesInfoImpl>
    implements _$$PowerProfilesInfoImplCopyWith<$Res> {
  __$$PowerProfilesInfoImplCopyWithImpl(_$PowerProfilesInfoImpl _value,
      $Res Function(_$PowerProfilesInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profile = null,
  }) {
    return _then(_$PowerProfilesInfoImpl(
      profile: null == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as PowerProfiles,
    ));
  }
}

/// @nodoc

class _$PowerProfilesInfoImpl implements _PowerProfilesInfo {
  const _$PowerProfilesInfoImpl({required this.profile});

  @override
  final PowerProfiles profile;

  @override
  String toString() {
    return 'PowerProfilesInfo(profile: $profile)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PowerProfilesInfoImpl &&
            (identical(other.profile, profile) || other.profile == profile));
  }

  @override
  int get hashCode => Object.hash(runtimeType, profile);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PowerProfilesInfoImplCopyWith<_$PowerProfilesInfoImpl> get copyWith =>
      __$$PowerProfilesInfoImplCopyWithImpl<_$PowerProfilesInfoImpl>(
          this, _$identity);
}

abstract class _PowerProfilesInfo implements PowerProfilesInfo {
  const factory _PowerProfilesInfo({required final PowerProfiles profile}) =
      _$PowerProfilesInfoImpl;

  @override
  PowerProfiles get profile;
  @override
  @JsonKey(ignore: true)
  _$$PowerProfilesInfoImplCopyWith<_$PowerProfilesInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
