// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sound.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SoundInfo {
  double get volume => throw _privateConstructorUsedError;
  bool get isMuted => throw _privateConstructorUsedError;

  /// Create a copy of SoundInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SoundInfoCopyWith<SoundInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SoundInfoCopyWith<$Res> {
  factory $SoundInfoCopyWith(SoundInfo value, $Res Function(SoundInfo) then) =
      _$SoundInfoCopyWithImpl<$Res, SoundInfo>;
  @useResult
  $Res call({double volume, bool isMuted});
}

/// @nodoc
class _$SoundInfoCopyWithImpl<$Res, $Val extends SoundInfo>
    implements $SoundInfoCopyWith<$Res> {
  _$SoundInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SoundInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? volume = null,
    Object? isMuted = null,
  }) {
    return _then(_value.copyWith(
      volume: null == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as double,
      isMuted: null == isMuted
          ? _value.isMuted
          : isMuted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SoundInfoImplCopyWith<$Res>
    implements $SoundInfoCopyWith<$Res> {
  factory _$$SoundInfoImplCopyWith(
          _$SoundInfoImpl value, $Res Function(_$SoundInfoImpl) then) =
      __$$SoundInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double volume, bool isMuted});
}

/// @nodoc
class __$$SoundInfoImplCopyWithImpl<$Res>
    extends _$SoundInfoCopyWithImpl<$Res, _$SoundInfoImpl>
    implements _$$SoundInfoImplCopyWith<$Res> {
  __$$SoundInfoImplCopyWithImpl(
      _$SoundInfoImpl _value, $Res Function(_$SoundInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of SoundInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? volume = null,
    Object? isMuted = null,
  }) {
    return _then(_$SoundInfoImpl(
      volume: null == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as double,
      isMuted: null == isMuted
          ? _value.isMuted
          : isMuted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SoundInfoImpl implements _SoundInfo {
  const _$SoundInfoImpl({required this.volume, required this.isMuted});

  @override
  final double volume;
  @override
  final bool isMuted;

  @override
  String toString() {
    return 'SoundInfo(volume: $volume, isMuted: $isMuted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SoundInfoImpl &&
            (identical(other.volume, volume) || other.volume == volume) &&
            (identical(other.isMuted, isMuted) || other.isMuted == isMuted));
  }

  @override
  int get hashCode => Object.hash(runtimeType, volume, isMuted);

  /// Create a copy of SoundInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SoundInfoImplCopyWith<_$SoundInfoImpl> get copyWith =>
      __$$SoundInfoImplCopyWithImpl<_$SoundInfoImpl>(this, _$identity);
}

abstract class _SoundInfo implements SoundInfo {
  const factory _SoundInfo(
      {required final double volume,
      required final bool isMuted}) = _$SoundInfoImpl;

  @override
  double get volume;
  @override
  bool get isMuted;

  /// Create a copy of SoundInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SoundInfoImplCopyWith<_$SoundInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
