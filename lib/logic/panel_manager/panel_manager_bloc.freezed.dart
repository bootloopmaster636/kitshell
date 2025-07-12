// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'panel_manager_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PanelManagerEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PanelManagerEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PanelManagerEvent()';
}


}

/// @nodoc
class $PanelManagerEventCopyWith<$Res>  {
$PanelManagerEventCopyWith(PanelManagerEvent _, $Res Function(PanelManagerEvent) __);
}


/// Adds pattern-matching-related methods to [PanelManagerEvent].
extension PanelManagerEventPatterns on PanelManagerEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PanelManagerEventStarted value)?  started,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PanelManagerEventStarted() when started != null:
return started(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PanelManagerEventStarted value)  started,}){
final _that = this;
switch (_that) {
case PanelManagerEventStarted():
return started(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PanelManagerEventStarted value)?  started,}){
final _that = this;
switch (_that) {
case PanelManagerEventStarted() when started != null:
return started(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PanelManagerEventStarted() when started != null:
return started();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,}) {final _that = this;
switch (_that) {
case PanelManagerEventStarted():
return started();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,}) {final _that = this;
switch (_that) {
case PanelManagerEventStarted() when started != null:
return started();case _:
  return null;

}
}

}

/// @nodoc


class PanelManagerEventStarted implements PanelManagerEvent {
  const PanelManagerEventStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PanelManagerEventStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PanelManagerEvent.started()';
}


}




/// @nodoc
mixin _$PanelManagerState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PanelManagerState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PanelManagerState()';
}


}

/// @nodoc
class $PanelManagerStateCopyWith<$Res>  {
$PanelManagerStateCopyWith(PanelManagerState _, $Res Function(PanelManagerState) __);
}


/// Adds pattern-matching-related methods to [PanelManagerState].
extension PanelManagerStatePatterns on PanelManagerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PanelManagerStateInitial value)?  initial,TResult Function( PanelManagerStateLoaded value)?  loaded,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PanelManagerStateInitial() when initial != null:
return initial(_that);case PanelManagerStateLoaded() when loaded != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PanelManagerStateInitial value)  initial,required TResult Function( PanelManagerStateLoaded value)  loaded,}){
final _that = this;
switch (_that) {
case PanelManagerStateInitial():
return initial(_that);case PanelManagerStateLoaded():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PanelManagerStateInitial value)?  initial,TResult? Function( PanelManagerStateLoaded value)?  loaded,}){
final _that = this;
switch (_that) {
case PanelManagerStateInitial() when initial != null:
return initial(_that);case PanelManagerStateLoaded() when loaded != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( List<Widget> componentsLeft,  List<Widget> componentsCenter,  List<Widget> componentsRight)?  loaded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PanelManagerStateInitial() when initial != null:
return initial();case PanelManagerStateLoaded() when loaded != null:
return loaded(_that.componentsLeft,_that.componentsCenter,_that.componentsRight);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( List<Widget> componentsLeft,  List<Widget> componentsCenter,  List<Widget> componentsRight)  loaded,}) {final _that = this;
switch (_that) {
case PanelManagerStateInitial():
return initial();case PanelManagerStateLoaded():
return loaded(_that.componentsLeft,_that.componentsCenter,_that.componentsRight);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( List<Widget> componentsLeft,  List<Widget> componentsCenter,  List<Widget> componentsRight)?  loaded,}) {final _that = this;
switch (_that) {
case PanelManagerStateInitial() when initial != null:
return initial();case PanelManagerStateLoaded() when loaded != null:
return loaded(_that.componentsLeft,_that.componentsCenter,_that.componentsRight);case _:
  return null;

}
}

}

/// @nodoc


class PanelManagerStateInitial implements PanelManagerState {
  const PanelManagerStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PanelManagerStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PanelManagerState.initial()';
}


}




/// @nodoc


class PanelManagerStateLoaded implements PanelManagerState {
  const PanelManagerStateLoaded({required final  List<Widget> componentsLeft, required final  List<Widget> componentsCenter, required final  List<Widget> componentsRight}): _componentsLeft = componentsLeft,_componentsCenter = componentsCenter,_componentsRight = componentsRight;
  

 final  List<Widget> _componentsLeft;
 List<Widget> get componentsLeft {
  if (_componentsLeft is EqualUnmodifiableListView) return _componentsLeft;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_componentsLeft);
}

 final  List<Widget> _componentsCenter;
 List<Widget> get componentsCenter {
  if (_componentsCenter is EqualUnmodifiableListView) return _componentsCenter;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_componentsCenter);
}

 final  List<Widget> _componentsRight;
 List<Widget> get componentsRight {
  if (_componentsRight is EqualUnmodifiableListView) return _componentsRight;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_componentsRight);
}


/// Create a copy of PanelManagerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PanelManagerStateLoadedCopyWith<PanelManagerStateLoaded> get copyWith => _$PanelManagerStateLoadedCopyWithImpl<PanelManagerStateLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PanelManagerStateLoaded&&const DeepCollectionEquality().equals(other._componentsLeft, _componentsLeft)&&const DeepCollectionEquality().equals(other._componentsCenter, _componentsCenter)&&const DeepCollectionEquality().equals(other._componentsRight, _componentsRight));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_componentsLeft),const DeepCollectionEquality().hash(_componentsCenter),const DeepCollectionEquality().hash(_componentsRight));

@override
String toString() {
  return 'PanelManagerState.loaded(componentsLeft: $componentsLeft, componentsCenter: $componentsCenter, componentsRight: $componentsRight)';
}


}

/// @nodoc
abstract mixin class $PanelManagerStateLoadedCopyWith<$Res> implements $PanelManagerStateCopyWith<$Res> {
  factory $PanelManagerStateLoadedCopyWith(PanelManagerStateLoaded value, $Res Function(PanelManagerStateLoaded) _then) = _$PanelManagerStateLoadedCopyWithImpl;
@useResult
$Res call({
 List<Widget> componentsLeft, List<Widget> componentsCenter, List<Widget> componentsRight
});




}
/// @nodoc
class _$PanelManagerStateLoadedCopyWithImpl<$Res>
    implements $PanelManagerStateLoadedCopyWith<$Res> {
  _$PanelManagerStateLoadedCopyWithImpl(this._self, this._then);

  final PanelManagerStateLoaded _self;
  final $Res Function(PanelManagerStateLoaded) _then;

/// Create a copy of PanelManagerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? componentsLeft = null,Object? componentsCenter = null,Object? componentsRight = null,}) {
  return _then(PanelManagerStateLoaded(
componentsLeft: null == componentsLeft ? _self._componentsLeft : componentsLeft // ignore: cast_nullable_to_non_nullable
as List<Widget>,componentsCenter: null == componentsCenter ? _self._componentsCenter : componentsCenter // ignore: cast_nullable_to_non_nullable
as List<Widget>,componentsRight: null == componentsRight ? _self._componentsRight : componentsRight // ignore: cast_nullable_to_non_nullable
as List<Widget>,
  ));
}


}

// dart format on
