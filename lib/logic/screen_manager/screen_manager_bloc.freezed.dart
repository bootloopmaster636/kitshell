// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'screen_manager_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScreenManagerEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScreenManagerEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ScreenManagerEvent()';
}


}

/// @nodoc
class $ScreenManagerEventCopyWith<$Res>  {
$ScreenManagerEventCopyWith(ScreenManagerEvent _, $Res Function(ScreenManagerEvent) __);
}


/// Adds pattern-matching-related methods to [ScreenManagerEvent].
extension ScreenManagerEventPatterns on ScreenManagerEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ScreenManagerEventStarted value)?  started,TResult Function( ScreenManagerEventOpenPopup value)?  openPopup,TResult Function( ScreenManagerEventClosePopup value)?  closePopup,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ScreenManagerEventStarted() when started != null:
return started(_that);case ScreenManagerEventOpenPopup() when openPopup != null:
return openPopup(_that);case ScreenManagerEventClosePopup() when closePopup != null:
return closePopup(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ScreenManagerEventStarted value)  started,required TResult Function( ScreenManagerEventOpenPopup value)  openPopup,required TResult Function( ScreenManagerEventClosePopup value)  closePopup,}){
final _that = this;
switch (_that) {
case ScreenManagerEventStarted():
return started(_that);case ScreenManagerEventOpenPopup():
return openPopup(_that);case ScreenManagerEventClosePopup():
return closePopup(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ScreenManagerEventStarted value)?  started,TResult? Function( ScreenManagerEventOpenPopup value)?  openPopup,TResult? Function( ScreenManagerEventClosePopup value)?  closePopup,}){
final _that = this;
switch (_that) {
case ScreenManagerEventStarted() when started != null:
return started(_that);case ScreenManagerEventOpenPopup() when openPopup != null:
return openPopup(_that);case ScreenManagerEventClosePopup() when closePopup != null:
return closePopup(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( PopupWidget popupToShow)?  openPopup,TResult Function()?  closePopup,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ScreenManagerEventStarted() when started != null:
return started();case ScreenManagerEventOpenPopup() when openPopup != null:
return openPopup(_that.popupToShow);case ScreenManagerEventClosePopup() when closePopup != null:
return closePopup();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( PopupWidget popupToShow)  openPopup,required TResult Function()  closePopup,}) {final _that = this;
switch (_that) {
case ScreenManagerEventStarted():
return started();case ScreenManagerEventOpenPopup():
return openPopup(_that.popupToShow);case ScreenManagerEventClosePopup():
return closePopup();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( PopupWidget popupToShow)?  openPopup,TResult? Function()?  closePopup,}) {final _that = this;
switch (_that) {
case ScreenManagerEventStarted() when started != null:
return started();case ScreenManagerEventOpenPopup() when openPopup != null:
return openPopup(_that.popupToShow);case ScreenManagerEventClosePopup() when closePopup != null:
return closePopup();case _:
  return null;

}
}

}

/// @nodoc


class ScreenManagerEventStarted implements ScreenManagerEvent {
  const ScreenManagerEventStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScreenManagerEventStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ScreenManagerEvent.started()';
}


}




/// @nodoc


class ScreenManagerEventOpenPopup implements ScreenManagerEvent {
  const ScreenManagerEventOpenPopup({required this.popupToShow});
  

 final  PopupWidget popupToShow;

/// Create a copy of ScreenManagerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScreenManagerEventOpenPopupCopyWith<ScreenManagerEventOpenPopup> get copyWith => _$ScreenManagerEventOpenPopupCopyWithImpl<ScreenManagerEventOpenPopup>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScreenManagerEventOpenPopup&&(identical(other.popupToShow, popupToShow) || other.popupToShow == popupToShow));
}


@override
int get hashCode => Object.hash(runtimeType,popupToShow);

@override
String toString() {
  return 'ScreenManagerEvent.openPopup(popupToShow: $popupToShow)';
}


}

/// @nodoc
abstract mixin class $ScreenManagerEventOpenPopupCopyWith<$Res> implements $ScreenManagerEventCopyWith<$Res> {
  factory $ScreenManagerEventOpenPopupCopyWith(ScreenManagerEventOpenPopup value, $Res Function(ScreenManagerEventOpenPopup) _then) = _$ScreenManagerEventOpenPopupCopyWithImpl;
@useResult
$Res call({
 PopupWidget popupToShow
});




}
/// @nodoc
class _$ScreenManagerEventOpenPopupCopyWithImpl<$Res>
    implements $ScreenManagerEventOpenPopupCopyWith<$Res> {
  _$ScreenManagerEventOpenPopupCopyWithImpl(this._self, this._then);

  final ScreenManagerEventOpenPopup _self;
  final $Res Function(ScreenManagerEventOpenPopup) _then;

/// Create a copy of ScreenManagerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? popupToShow = null,}) {
  return _then(ScreenManagerEventOpenPopup(
popupToShow: null == popupToShow ? _self.popupToShow : popupToShow // ignore: cast_nullable_to_non_nullable
as PopupWidget,
  ));
}


}

/// @nodoc


class ScreenManagerEventClosePopup implements ScreenManagerEvent {
  const ScreenManagerEventClosePopup();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScreenManagerEventClosePopup);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ScreenManagerEvent.closePopup()';
}


}




/// @nodoc
mixin _$ScreenManagerState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScreenManagerState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ScreenManagerState()';
}


}

/// @nodoc
class $ScreenManagerStateCopyWith<$Res>  {
$ScreenManagerStateCopyWith(ScreenManagerState _, $Res Function(ScreenManagerState) __);
}


/// Adds pattern-matching-related methods to [ScreenManagerState].
extension ScreenManagerStatePatterns on ScreenManagerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ScreenManagerStateInitial value)?  initial,TResult Function( ScreenManagerStateLoaded value)?  loaded,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ScreenManagerStateInitial() when initial != null:
return initial(_that);case ScreenManagerStateLoaded() when loaded != null:
return loaded(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ScreenManagerStateInitial value)  initial,required TResult Function( ScreenManagerStateLoaded value)  loaded,}){
final _that = this;
switch (_that) {
case ScreenManagerStateInitial():
return initial(_that);case ScreenManagerStateLoaded():
return loaded(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ScreenManagerStateInitial value)?  initial,TResult? Function( ScreenManagerStateLoaded value)?  loaded,}){
final _that = this;
switch (_that) {
case ScreenManagerStateInitial() when initial != null:
return initial(_that);case ScreenManagerStateLoaded() when loaded != null:
return loaded(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( ScreenStateModel layerState)?  loaded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ScreenManagerStateInitial() when initial != null:
return initial();case ScreenManagerStateLoaded() when loaded != null:
return loaded(_that.layerState);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( ScreenStateModel layerState)  loaded,}) {final _that = this;
switch (_that) {
case ScreenManagerStateInitial():
return initial();case ScreenManagerStateLoaded():
return loaded(_that.layerState);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( ScreenStateModel layerState)?  loaded,}) {final _that = this;
switch (_that) {
case ScreenManagerStateInitial() when initial != null:
return initial();case ScreenManagerStateLoaded() when loaded != null:
return loaded(_that.layerState);case _:
  return null;

}
}

}

/// @nodoc


class ScreenManagerStateInitial implements ScreenManagerState {
  const ScreenManagerStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScreenManagerStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ScreenManagerState.initial()';
}


}




/// @nodoc


class ScreenManagerStateLoaded implements ScreenManagerState {
  const ScreenManagerStateLoaded(this.layerState);
  

 final  ScreenStateModel layerState;

/// Create a copy of ScreenManagerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScreenManagerStateLoadedCopyWith<ScreenManagerStateLoaded> get copyWith => _$ScreenManagerStateLoadedCopyWithImpl<ScreenManagerStateLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScreenManagerStateLoaded&&(identical(other.layerState, layerState) || other.layerState == layerState));
}


@override
int get hashCode => Object.hash(runtimeType,layerState);

@override
String toString() {
  return 'ScreenManagerState.loaded(layerState: $layerState)';
}


}

/// @nodoc
abstract mixin class $ScreenManagerStateLoadedCopyWith<$Res> implements $ScreenManagerStateCopyWith<$Res> {
  factory $ScreenManagerStateLoadedCopyWith(ScreenManagerStateLoaded value, $Res Function(ScreenManagerStateLoaded) _then) = _$ScreenManagerStateLoadedCopyWithImpl;
@useResult
$Res call({
 ScreenStateModel layerState
});


$ScreenStateModelCopyWith<$Res> get layerState;

}
/// @nodoc
class _$ScreenManagerStateLoadedCopyWithImpl<$Res>
    implements $ScreenManagerStateLoadedCopyWith<$Res> {
  _$ScreenManagerStateLoadedCopyWithImpl(this._self, this._then);

  final ScreenManagerStateLoaded _self;
  final $Res Function(ScreenManagerStateLoaded) _then;

/// Create a copy of ScreenManagerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? layerState = null,}) {
  return _then(ScreenManagerStateLoaded(
null == layerState ? _self.layerState : layerState // ignore: cast_nullable_to_non_nullable
as ScreenStateModel,
  ));
}

/// Create a copy of ScreenManagerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScreenStateModelCopyWith<$Res> get layerState {
  
  return $ScreenStateModelCopyWith<$Res>(_self.layerState, (value) {
    return _then(_self.copyWith(layerState: value));
  });
}
}

// dart format on
