// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'look_and_feel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LookAndFeel {
  ThemeModeOption get themeMode => throw _privateConstructorUsedError;
  Color get color => throw _privateConstructorUsedError;

  /// Create a copy of LookAndFeel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LookAndFeelCopyWith<LookAndFeel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LookAndFeelCopyWith<$Res> {
  factory $LookAndFeelCopyWith(
          LookAndFeel value, $Res Function(LookAndFeel) then) =
      _$LookAndFeelCopyWithImpl<$Res, LookAndFeel>;
  @useResult
  $Res call({ThemeModeOption themeMode, Color color});
}

/// @nodoc
class _$LookAndFeelCopyWithImpl<$Res, $Val extends LookAndFeel>
    implements $LookAndFeelCopyWith<$Res> {
  _$LookAndFeelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LookAndFeel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? color = null,
  }) {
    return _then(_value.copyWith(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeModeOption,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LookAndFeelImplCopyWith<$Res>
    implements $LookAndFeelCopyWith<$Res> {
  factory _$$LookAndFeelImplCopyWith(
          _$LookAndFeelImpl value, $Res Function(_$LookAndFeelImpl) then) =
      __$$LookAndFeelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ThemeModeOption themeMode, Color color});
}

/// @nodoc
class __$$LookAndFeelImplCopyWithImpl<$Res>
    extends _$LookAndFeelCopyWithImpl<$Res, _$LookAndFeelImpl>
    implements _$$LookAndFeelImplCopyWith<$Res> {
  __$$LookAndFeelImplCopyWithImpl(
      _$LookAndFeelImpl _value, $Res Function(_$LookAndFeelImpl) _then)
      : super(_value, _then);

  /// Create a copy of LookAndFeel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? color = null,
  }) {
    return _then(_$LookAndFeelImpl(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeModeOption,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
    ));
  }
}

/// @nodoc

class _$LookAndFeelImpl implements _LookAndFeel {
  const _$LookAndFeelImpl({required this.themeMode, required this.color});

  @override
  final ThemeModeOption themeMode;
  @override
  final Color color;

  @override
  String toString() {
    return 'LookAndFeel(themeMode: $themeMode, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LookAndFeelImpl &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.color, color) || other.color == color));
  }

  @override
  int get hashCode => Object.hash(runtimeType, themeMode, color);

  /// Create a copy of LookAndFeel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LookAndFeelImplCopyWith<_$LookAndFeelImpl> get copyWith =>
      __$$LookAndFeelImplCopyWithImpl<_$LookAndFeelImpl>(this, _$identity);
}

abstract class _LookAndFeel implements LookAndFeel {
  const factory _LookAndFeel(
      {required final ThemeModeOption themeMode,
      required final Color color}) = _$LookAndFeelImpl;

  @override
  ThemeModeOption get themeMode;
  @override
  Color get color;

  /// Create a copy of LookAndFeel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LookAndFeelImplCopyWith<_$LookAndFeelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
