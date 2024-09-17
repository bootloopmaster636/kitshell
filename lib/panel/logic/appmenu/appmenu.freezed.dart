// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appmenu.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppmenuInfo {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get exec => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  bool get useTerminal => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  int get frequency => throw _privateConstructorUsedError;

  /// Create a copy of AppmenuInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppmenuInfoCopyWith<AppmenuInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppmenuInfoCopyWith<$Res> {
  factory $AppmenuInfoCopyWith(
          AppmenuInfo value, $Res Function(AppmenuInfo) then) =
      _$AppmenuInfoCopyWithImpl<$Res, AppmenuInfo>;
  @useResult
  $Res call(
      {int id,
      String name,
      String description,
      List<String> exec,
      String icon,
      bool useTerminal,
      bool isFavorite,
      int frequency});
}

/// @nodoc
class _$AppmenuInfoCopyWithImpl<$Res, $Val extends AppmenuInfo>
    implements $AppmenuInfoCopyWith<$Res> {
  _$AppmenuInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppmenuInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? exec = null,
    Object? icon = null,
    Object? useTerminal = null,
    Object? isFavorite = null,
    Object? frequency = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      exec: null == exec
          ? _value.exec
          : exec // ignore: cast_nullable_to_non_nullable
              as List<String>,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      useTerminal: null == useTerminal
          ? _value.useTerminal
          : useTerminal // ignore: cast_nullable_to_non_nullable
              as bool,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppmenuInfoImplCopyWith<$Res>
    implements $AppmenuInfoCopyWith<$Res> {
  factory _$$AppmenuInfoImplCopyWith(
          _$AppmenuInfoImpl value, $Res Function(_$AppmenuInfoImpl) then) =
      __$$AppmenuInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String description,
      List<String> exec,
      String icon,
      bool useTerminal,
      bool isFavorite,
      int frequency});
}

/// @nodoc
class __$$AppmenuInfoImplCopyWithImpl<$Res>
    extends _$AppmenuInfoCopyWithImpl<$Res, _$AppmenuInfoImpl>
    implements _$$AppmenuInfoImplCopyWith<$Res> {
  __$$AppmenuInfoImplCopyWithImpl(
      _$AppmenuInfoImpl _value, $Res Function(_$AppmenuInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppmenuInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? exec = null,
    Object? icon = null,
    Object? useTerminal = null,
    Object? isFavorite = null,
    Object? frequency = null,
  }) {
    return _then(_$AppmenuInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      exec: null == exec
          ? _value._exec
          : exec // ignore: cast_nullable_to_non_nullable
              as List<String>,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      useTerminal: null == useTerminal
          ? _value.useTerminal
          : useTerminal // ignore: cast_nullable_to_non_nullable
              as bool,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$AppmenuInfoImpl implements _AppmenuInfo {
  const _$AppmenuInfoImpl(
      {required this.id,
      required this.name,
      required this.description,
      required final List<String> exec,
      required this.icon,
      required this.useTerminal,
      required this.isFavorite,
      required this.frequency})
      : _exec = exec;

  @override
  final int id;
  @override
  final String name;
  @override
  final String description;
  final List<String> _exec;
  @override
  List<String> get exec {
    if (_exec is EqualUnmodifiableListView) return _exec;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exec);
  }

  @override
  final String icon;
  @override
  final bool useTerminal;
  @override
  final bool isFavorite;
  @override
  final int frequency;

  @override
  String toString() {
    return 'AppmenuInfo(id: $id, name: $name, description: $description, exec: $exec, icon: $icon, useTerminal: $useTerminal, isFavorite: $isFavorite, frequency: $frequency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppmenuInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._exec, _exec) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.useTerminal, useTerminal) ||
                other.useTerminal == useTerminal) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      const DeepCollectionEquality().hash(_exec),
      icon,
      useTerminal,
      isFavorite,
      frequency);

  /// Create a copy of AppmenuInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppmenuInfoImplCopyWith<_$AppmenuInfoImpl> get copyWith =>
      __$$AppmenuInfoImplCopyWithImpl<_$AppmenuInfoImpl>(this, _$identity);
}

abstract class _AppmenuInfo implements AppmenuInfo {
  const factory _AppmenuInfo(
      {required final int id,
      required final String name,
      required final String description,
      required final List<String> exec,
      required final String icon,
      required final bool useTerminal,
      required final bool isFavorite,
      required final int frequency}) = _$AppmenuInfoImpl;

  @override
  int get id;
  @override
  String get name;
  @override
  String get description;
  @override
  List<String> get exec;
  @override
  String get icon;
  @override
  bool get useTerminal;
  @override
  bool get isFavorite;
  @override
  int get frequency;

  /// Create a copy of AppmenuInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppmenuInfoImplCopyWith<_$AppmenuInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AppmenuData {
  List<AppmenuInfo> get appmenuNoFav => throw _privateConstructorUsedError;
  List<AppmenuInfo> get appmenuFav => throw _privateConstructorUsedError;

  /// Create a copy of AppmenuData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppmenuDataCopyWith<AppmenuData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppmenuDataCopyWith<$Res> {
  factory $AppmenuDataCopyWith(
          AppmenuData value, $Res Function(AppmenuData) then) =
      _$AppmenuDataCopyWithImpl<$Res, AppmenuData>;
  @useResult
  $Res call({List<AppmenuInfo> appmenuNoFav, List<AppmenuInfo> appmenuFav});
}

/// @nodoc
class _$AppmenuDataCopyWithImpl<$Res, $Val extends AppmenuData>
    implements $AppmenuDataCopyWith<$Res> {
  _$AppmenuDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppmenuData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appmenuNoFav = null,
    Object? appmenuFav = null,
  }) {
    return _then(_value.copyWith(
      appmenuNoFav: null == appmenuNoFav
          ? _value.appmenuNoFav
          : appmenuNoFav // ignore: cast_nullable_to_non_nullable
              as List<AppmenuInfo>,
      appmenuFav: null == appmenuFav
          ? _value.appmenuFav
          : appmenuFav // ignore: cast_nullable_to_non_nullable
              as List<AppmenuInfo>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppmenuDataImplCopyWith<$Res>
    implements $AppmenuDataCopyWith<$Res> {
  factory _$$AppmenuDataImplCopyWith(
          _$AppmenuDataImpl value, $Res Function(_$AppmenuDataImpl) then) =
      __$$AppmenuDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<AppmenuInfo> appmenuNoFav, List<AppmenuInfo> appmenuFav});
}

/// @nodoc
class __$$AppmenuDataImplCopyWithImpl<$Res>
    extends _$AppmenuDataCopyWithImpl<$Res, _$AppmenuDataImpl>
    implements _$$AppmenuDataImplCopyWith<$Res> {
  __$$AppmenuDataImplCopyWithImpl(
      _$AppmenuDataImpl _value, $Res Function(_$AppmenuDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppmenuData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appmenuNoFav = null,
    Object? appmenuFav = null,
  }) {
    return _then(_$AppmenuDataImpl(
      appmenuNoFav: null == appmenuNoFav
          ? _value._appmenuNoFav
          : appmenuNoFav // ignore: cast_nullable_to_non_nullable
              as List<AppmenuInfo>,
      appmenuFav: null == appmenuFav
          ? _value._appmenuFav
          : appmenuFav // ignore: cast_nullable_to_non_nullable
              as List<AppmenuInfo>,
    ));
  }
}

/// @nodoc

class _$AppmenuDataImpl implements _AppmenuData {
  const _$AppmenuDataImpl(
      {required final List<AppmenuInfo> appmenuNoFav,
      required final List<AppmenuInfo> appmenuFav})
      : _appmenuNoFav = appmenuNoFav,
        _appmenuFav = appmenuFav;

  final List<AppmenuInfo> _appmenuNoFav;
  @override
  List<AppmenuInfo> get appmenuNoFav {
    if (_appmenuNoFav is EqualUnmodifiableListView) return _appmenuNoFav;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_appmenuNoFav);
  }

  final List<AppmenuInfo> _appmenuFav;
  @override
  List<AppmenuInfo> get appmenuFav {
    if (_appmenuFav is EqualUnmodifiableListView) return _appmenuFav;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_appmenuFav);
  }

  @override
  String toString() {
    return 'AppmenuData(appmenuNoFav: $appmenuNoFav, appmenuFav: $appmenuFav)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppmenuDataImpl &&
            const DeepCollectionEquality()
                .equals(other._appmenuNoFav, _appmenuNoFav) &&
            const DeepCollectionEquality()
                .equals(other._appmenuFav, _appmenuFav));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_appmenuNoFav),
      const DeepCollectionEquality().hash(_appmenuFav));

  /// Create a copy of AppmenuData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppmenuDataImplCopyWith<_$AppmenuDataImpl> get copyWith =>
      __$$AppmenuDataImplCopyWithImpl<_$AppmenuDataImpl>(this, _$identity);
}

abstract class _AppmenuData implements AppmenuData {
  const factory _AppmenuData(
      {required final List<AppmenuInfo> appmenuNoFav,
      required final List<AppmenuInfo> appmenuFav}) = _$AppmenuDataImpl;

  @override
  List<AppmenuInfo> get appmenuNoFav;
  @override
  List<AppmenuInfo> get appmenuFav;

  /// Create a copy of AppmenuData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppmenuDataImplCopyWith<_$AppmenuDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
