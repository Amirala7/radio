// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'station_popularity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StationPopularity {

 int? get global; Map<String, int>? get byCountry;
/// Create a copy of StationPopularity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StationPopularityCopyWith<StationPopularity> get copyWith => _$StationPopularityCopyWithImpl<StationPopularity>(this as StationPopularity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StationPopularity&&(identical(other.global, global) || other.global == global)&&const DeepCollectionEquality().equals(other.byCountry, byCountry));
}


@override
int get hashCode => Object.hash(runtimeType,global,const DeepCollectionEquality().hash(byCountry));

@override
String toString() {
  return 'StationPopularity(global: $global, byCountry: $byCountry)';
}


}

/// @nodoc
abstract mixin class $StationPopularityCopyWith<$Res>  {
  factory $StationPopularityCopyWith(StationPopularity value, $Res Function(StationPopularity) _then) = _$StationPopularityCopyWithImpl;
@useResult
$Res call({
 int? global, Map<String, int>? byCountry
});




}
/// @nodoc
class _$StationPopularityCopyWithImpl<$Res>
    implements $StationPopularityCopyWith<$Res> {
  _$StationPopularityCopyWithImpl(this._self, this._then);

  final StationPopularity _self;
  final $Res Function(StationPopularity) _then;

/// Create a copy of StationPopularity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? global = freezed,Object? byCountry = freezed,}) {
  return _then(_self.copyWith(
global: freezed == global ? _self.global : global // ignore: cast_nullable_to_non_nullable
as int?,byCountry: freezed == byCountry ? _self.byCountry : byCountry // ignore: cast_nullable_to_non_nullable
as Map<String, int>?,
  ));
}

}


/// Adds pattern-matching-related methods to [StationPopularity].
extension StationPopularityPatterns on StationPopularity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StationPopularity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StationPopularity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StationPopularity value)  $default,){
final _that = this;
switch (_that) {
case _StationPopularity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StationPopularity value)?  $default,){
final _that = this;
switch (_that) {
case _StationPopularity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? global,  Map<String, int>? byCountry)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StationPopularity() when $default != null:
return $default(_that.global,_that.byCountry);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? global,  Map<String, int>? byCountry)  $default,) {final _that = this;
switch (_that) {
case _StationPopularity():
return $default(_that.global,_that.byCountry);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? global,  Map<String, int>? byCountry)?  $default,) {final _that = this;
switch (_that) {
case _StationPopularity() when $default != null:
return $default(_that.global,_that.byCountry);case _:
  return null;

}
}

}

/// @nodoc


class _StationPopularity implements StationPopularity {
  const _StationPopularity({this.global, final  Map<String, int>? byCountry}): _byCountry = byCountry;
  

@override final  int? global;
 final  Map<String, int>? _byCountry;
@override Map<String, int>? get byCountry {
  final value = _byCountry;
  if (value == null) return null;
  if (_byCountry is EqualUnmodifiableMapView) return _byCountry;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of StationPopularity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StationPopularityCopyWith<_StationPopularity> get copyWith => __$StationPopularityCopyWithImpl<_StationPopularity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StationPopularity&&(identical(other.global, global) || other.global == global)&&const DeepCollectionEquality().equals(other._byCountry, _byCountry));
}


@override
int get hashCode => Object.hash(runtimeType,global,const DeepCollectionEquality().hash(_byCountry));

@override
String toString() {
  return 'StationPopularity(global: $global, byCountry: $byCountry)';
}


}

/// @nodoc
abstract mixin class _$StationPopularityCopyWith<$Res> implements $StationPopularityCopyWith<$Res> {
  factory _$StationPopularityCopyWith(_StationPopularity value, $Res Function(_StationPopularity) _then) = __$StationPopularityCopyWithImpl;
@override @useResult
$Res call({
 int? global, Map<String, int>? byCountry
});




}
/// @nodoc
class __$StationPopularityCopyWithImpl<$Res>
    implements _$StationPopularityCopyWith<$Res> {
  __$StationPopularityCopyWithImpl(this._self, this._then);

  final _StationPopularity _self;
  final $Res Function(_StationPopularity) _then;

/// Create a copy of StationPopularity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? global = freezed,Object? byCountry = freezed,}) {
  return _then(_StationPopularity(
global: freezed == global ? _self.global : global // ignore: cast_nullable_to_non_nullable
as int?,byCountry: freezed == byCountry ? _self._byCountry : byCountry // ignore: cast_nullable_to_non_nullable
as Map<String, int>?,
  ));
}


}

// dart format on
