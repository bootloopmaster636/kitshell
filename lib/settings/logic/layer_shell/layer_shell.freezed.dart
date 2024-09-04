// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'layer_shell.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LayerShellData {
  int get panelWidth => throw _privateConstructorUsedError;
  int get panelHeight => throw _privateConstructorUsedError;
  ShellEdge get anchor => throw _privateConstructorUsedError;
  ShellLayer get layer => throw _privateConstructorUsedError;
  Monitor? get monitor => throw _privateConstructorUsedError;

  /// Create a copy of LayerShellData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LayerShellDataCopyWith<LayerShellData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LayerShellDataCopyWith<$Res> {
  factory $LayerShellDataCopyWith(
          LayerShellData value, $Res Function(LayerShellData) then) =
      _$LayerShellDataCopyWithImpl<$Res, LayerShellData>;
  @useResult
  $Res call(
      {int panelWidth,
      int panelHeight,
      ShellEdge anchor,
      ShellLayer layer,
      Monitor? monitor});
}

/// @nodoc
class _$LayerShellDataCopyWithImpl<$Res, $Val extends LayerShellData>
    implements $LayerShellDataCopyWith<$Res> {
  _$LayerShellDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LayerShellData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? panelWidth = null,
    Object? panelHeight = null,
    Object? anchor = null,
    Object? layer = null,
    Object? monitor = freezed,
  }) {
    return _then(_value.copyWith(
      panelWidth: null == panelWidth
          ? _value.panelWidth
          : panelWidth // ignore: cast_nullable_to_non_nullable
              as int,
      panelHeight: null == panelHeight
          ? _value.panelHeight
          : panelHeight // ignore: cast_nullable_to_non_nullable
              as int,
      anchor: null == anchor
          ? _value.anchor
          : anchor // ignore: cast_nullable_to_non_nullable
              as ShellEdge,
      layer: null == layer
          ? _value.layer
          : layer // ignore: cast_nullable_to_non_nullable
              as ShellLayer,
      monitor: freezed == monitor
          ? _value.monitor
          : monitor // ignore: cast_nullable_to_non_nullable
              as Monitor?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LayerShellDataImplCopyWith<$Res>
    implements $LayerShellDataCopyWith<$Res> {
  factory _$$LayerShellDataImplCopyWith(_$LayerShellDataImpl value,
          $Res Function(_$LayerShellDataImpl) then) =
      __$$LayerShellDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int panelWidth,
      int panelHeight,
      ShellEdge anchor,
      ShellLayer layer,
      Monitor? monitor});
}

/// @nodoc
class __$$LayerShellDataImplCopyWithImpl<$Res>
    extends _$LayerShellDataCopyWithImpl<$Res, _$LayerShellDataImpl>
    implements _$$LayerShellDataImplCopyWith<$Res> {
  __$$LayerShellDataImplCopyWithImpl(
      _$LayerShellDataImpl _value, $Res Function(_$LayerShellDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of LayerShellData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? panelWidth = null,
    Object? panelHeight = null,
    Object? anchor = null,
    Object? layer = null,
    Object? monitor = freezed,
  }) {
    return _then(_$LayerShellDataImpl(
      panelWidth: null == panelWidth
          ? _value.panelWidth
          : panelWidth // ignore: cast_nullable_to_non_nullable
              as int,
      panelHeight: null == panelHeight
          ? _value.panelHeight
          : panelHeight // ignore: cast_nullable_to_non_nullable
              as int,
      anchor: null == anchor
          ? _value.anchor
          : anchor // ignore: cast_nullable_to_non_nullable
              as ShellEdge,
      layer: null == layer
          ? _value.layer
          : layer // ignore: cast_nullable_to_non_nullable
              as ShellLayer,
      monitor: freezed == monitor
          ? _value.monitor
          : monitor // ignore: cast_nullable_to_non_nullable
              as Monitor?,
    ));
  }
}

/// @nodoc

class _$LayerShellDataImpl implements _LayerShellData {
  const _$LayerShellDataImpl(
      {required this.panelWidth,
      required this.panelHeight,
      required this.anchor,
      required this.layer,
      this.monitor});

  @override
  final int panelWidth;
  @override
  final int panelHeight;
  @override
  final ShellEdge anchor;
  @override
  final ShellLayer layer;
  @override
  final Monitor? monitor;

  @override
  String toString() {
    return 'LayerShellData(panelWidth: $panelWidth, panelHeight: $panelHeight, anchor: $anchor, layer: $layer, monitor: $monitor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LayerShellDataImpl &&
            (identical(other.panelWidth, panelWidth) ||
                other.panelWidth == panelWidth) &&
            (identical(other.panelHeight, panelHeight) ||
                other.panelHeight == panelHeight) &&
            (identical(other.anchor, anchor) || other.anchor == anchor) &&
            (identical(other.layer, layer) || other.layer == layer) &&
            (identical(other.monitor, monitor) || other.monitor == monitor));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, panelWidth, panelHeight, anchor, layer, monitor);

  /// Create a copy of LayerShellData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LayerShellDataImplCopyWith<_$LayerShellDataImpl> get copyWith =>
      __$$LayerShellDataImplCopyWithImpl<_$LayerShellDataImpl>(
          this, _$identity);
}

abstract class _LayerShellData implements LayerShellData {
  const factory _LayerShellData(
      {required final int panelWidth,
      required final int panelHeight,
      required final ShellEdge anchor,
      required final ShellLayer layer,
      final Monitor? monitor}) = _$LayerShellDataImpl;

  @override
  int get panelWidth;
  @override
  int get panelHeight;
  @override
  ShellEdge get anchor;
  @override
  ShellLayer get layer;
  @override
  Monitor? get monitor;

  /// Create a copy of LayerShellData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LayerShellDataImplCopyWith<_$LayerShellDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
