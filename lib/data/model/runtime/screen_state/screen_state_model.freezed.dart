// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'screen_state_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScreenStateModel {

 bool get isPopupShown; PopupWidget? get popupShown;
/// Create a copy of ScreenStateModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScreenStateModelCopyWith<ScreenStateModel> get copyWith => _$ScreenStateModelCopyWithImpl<ScreenStateModel>(this as ScreenStateModel, _$identity);

  /// Serializes this ScreenStateModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScreenStateModel&&(identical(other.isPopupShown, isPopupShown) || other.isPopupShown == isPopupShown)&&(identical(other.popupShown, popupShown) || other.popupShown == popupShown));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isPopupShown,popupShown);

@override
String toString() {
  return 'ScreenStateModel(isPopupShown: $isPopupShown, popupShown: $popupShown)';
}


}

/// @nodoc
abstract mixin class $ScreenStateModelCopyWith<$Res>  {
  factory $ScreenStateModelCopyWith(ScreenStateModel value, $Res Function(ScreenStateModel) _then) = _$ScreenStateModelCopyWithImpl;
@useResult
$Res call({
 bool isPopupShown, PopupWidget? popupShown
});




}
/// @nodoc
class _$ScreenStateModelCopyWithImpl<$Res>
    implements $ScreenStateModelCopyWith<$Res> {
  _$ScreenStateModelCopyWithImpl(this._self, this._then);

  final ScreenStateModel _self;
  final $Res Function(ScreenStateModel) _then;

/// Create a copy of ScreenStateModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isPopupShown = null,Object? popupShown = freezed,}) {
  return _then(_self.copyWith(
isPopupShown: null == isPopupShown ? _self.isPopupShown : isPopupShown // ignore: cast_nullable_to_non_nullable
as bool,popupShown: freezed == popupShown ? _self.popupShown : popupShown // ignore: cast_nullable_to_non_nullable
as PopupWidget?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScreenStateModel].
extension ScreenStateModelPatterns on ScreenStateModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScreenStateModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScreenStateModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScreenStateModel value)  $default,){
final _that = this;
switch (_that) {
case _ScreenStateModel():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScreenStateModel value)?  $default,){
final _that = this;
switch (_that) {
case _ScreenStateModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isPopupShown,  PopupWidget? popupShown)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScreenStateModel() when $default != null:
return $default(_that.isPopupShown,_that.popupShown);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isPopupShown,  PopupWidget? popupShown)  $default,) {final _that = this;
switch (_that) {
case _ScreenStateModel():
return $default(_that.isPopupShown,_that.popupShown);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isPopupShown,  PopupWidget? popupShown)?  $default,) {final _that = this;
switch (_that) {
case _ScreenStateModel() when $default != null:
return $default(_that.isPopupShown,_that.popupShown);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScreenStateModel implements ScreenStateModel {
  const _ScreenStateModel({required this.isPopupShown, this.popupShown});
  factory _ScreenStateModel.fromJson(Map<String, dynamic> json) => _$ScreenStateModelFromJson(json);

@override final  bool isPopupShown;
@override final  PopupWidget? popupShown;

/// Create a copy of ScreenStateModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScreenStateModelCopyWith<_ScreenStateModel> get copyWith => __$ScreenStateModelCopyWithImpl<_ScreenStateModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScreenStateModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScreenStateModel&&(identical(other.isPopupShown, isPopupShown) || other.isPopupShown == isPopupShown)&&(identical(other.popupShown, popupShown) || other.popupShown == popupShown));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isPopupShown,popupShown);

@override
String toString() {
  return 'ScreenStateModel(isPopupShown: $isPopupShown, popupShown: $popupShown)';
}


}

/// @nodoc
abstract mixin class _$ScreenStateModelCopyWith<$Res> implements $ScreenStateModelCopyWith<$Res> {
  factory _$ScreenStateModelCopyWith(_ScreenStateModel value, $Res Function(_ScreenStateModel) _then) = __$ScreenStateModelCopyWithImpl;
@override @useResult
$Res call({
 bool isPopupShown, PopupWidget? popupShown
});




}
/// @nodoc
class __$ScreenStateModelCopyWithImpl<$Res>
    implements _$ScreenStateModelCopyWith<$Res> {
  __$ScreenStateModelCopyWithImpl(this._self, this._then);

  final _ScreenStateModel _self;
  final $Res Function(_ScreenStateModel) _then;

/// Create a copy of ScreenStateModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isPopupShown = null,Object? popupShown = freezed,}) {
  return _then(_ScreenStateModel(
isPopupShown: null == isPopupShown ? _self.isPopupShown : isPopupShown // ignore: cast_nullable_to_non_nullable
as bool,popupShown: freezed == popupShown ? _self.popupShown : popupShown // ignore: cast_nullable_to_non_nullable
as PopupWidget?,
  ));
}


}

// dart format on
