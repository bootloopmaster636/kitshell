// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TimeInfo {
  DateTime get time => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TimeInfoCopyWith<TimeInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeInfoCopyWith<$Res> {
  factory $TimeInfoCopyWith(TimeInfo value, $Res Function(TimeInfo) then) =
      _$TimeInfoCopyWithImpl<$Res, TimeInfo>;
  @useResult
  $Res call({DateTime time});
}

/// @nodoc
class _$TimeInfoCopyWithImpl<$Res, $Val extends TimeInfo>
    implements $TimeInfoCopyWith<$Res> {
  _$TimeInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
  }) {
    return _then(_value.copyWith(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimeInfoImplCopyWith<$Res>
    implements $TimeInfoCopyWith<$Res> {
  factory _$$TimeInfoImplCopyWith(
          _$TimeInfoImpl value, $Res Function(_$TimeInfoImpl) then) =
      __$$TimeInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime time});
}

/// @nodoc
class __$$TimeInfoImplCopyWithImpl<$Res>
    extends _$TimeInfoCopyWithImpl<$Res, _$TimeInfoImpl>
    implements _$$TimeInfoImplCopyWith<$Res> {
  __$$TimeInfoImplCopyWithImpl(
      _$TimeInfoImpl _value, $Res Function(_$TimeInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
  }) {
    return _then(_$TimeInfoImpl(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$TimeInfoImpl implements _TimeInfo {
  const _$TimeInfoImpl({required this.time});

  @override
  final DateTime time;

  @override
  String toString() {
    return 'TimeInfo(time: $time)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeInfoImpl &&
            (identical(other.time, time) || other.time == time));
  }

  @override
  int get hashCode => Object.hash(runtimeType, time);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeInfoImplCopyWith<_$TimeInfoImpl> get copyWith =>
      __$$TimeInfoImplCopyWithImpl<_$TimeInfoImpl>(this, _$identity);
}

abstract class _TimeInfo implements TimeInfo {
  const factory _TimeInfo({required final DateTime time}) = _$TimeInfoImpl;

  @override
  DateTime get time;
  @override
  @JsonKey(ignore: true)
  _$$TimeInfoImplCopyWith<_$TimeInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
