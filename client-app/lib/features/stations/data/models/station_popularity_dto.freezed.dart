// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'station_popularity_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StationPopularityDto {

 int? get global; Map<String, int>? get byCountry;
/// Create a copy of StationPopularityDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StationPopularityDtoCopyWith<StationPopularityDto> get copyWith => _$StationPopularityDtoCopyWithImpl<StationPopularityDto>(this as StationPopularityDto, _$identity);

  /// Serializes this StationPopularityDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StationPopularityDto&&(identical(other.global, global) || other.global == global)&&const DeepCollectionEquality().equals(other.byCountry, byCountry));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,global,const DeepCollectionEquality().hash(byCountry));

@override
String toString() {
  return 'StationPopularityDto(global: $global, byCountry: $byCountry)';
}


}

/// @nodoc
abstract mixin class $StationPopularityDtoCopyWith<$Res>  {
  factory $StationPopularityDtoCopyWith(StationPopularityDto value, $Res Function(StationPopularityDto) _then) = _$StationPopularityDtoCopyWithImpl;
@useResult
$Res call({
 int? global, Map<String, int>? byCountry
});




}
/// @nodoc
class _$StationPopularityDtoCopyWithImpl<$Res>
    implements $StationPopularityDtoCopyWith<$Res> {
  _$StationPopularityDtoCopyWithImpl(this._self, this._then);

  final StationPopularityDto _self;
  final $Res Function(StationPopularityDto) _then;

/// Create a copy of StationPopularityDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? global = freezed,Object? byCountry = freezed,}) {
  return _then(_self.copyWith(
global: freezed == global ? _self.global : global // ignore: cast_nullable_to_non_nullable
as int?,byCountry: freezed == byCountry ? _self.byCountry : byCountry // ignore: cast_nullable_to_non_nullable
as Map<String, int>?,
  ));
}

}


/// Adds pattern-matching-related methods to [StationPopularityDto].
extension StationPopularityDtoPatterns on StationPopularityDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StationPopularityDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StationPopularityDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StationPopularityDto value)  $default,){
final _that = this;
switch (_that) {
case _StationPopularityDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StationPopularityDto value)?  $default,){
final _that = this;
switch (_that) {
case _StationPopularityDto() when $default != null:
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
case _StationPopularityDto() when $default != null:
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
case _StationPopularityDto():
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
case _StationPopularityDto() when $default != null:
return $default(_that.global,_that.byCountry);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StationPopularityDto implements StationPopularityDto {
  const _StationPopularityDto({this.global, final  Map<String, int>? byCountry}): _byCountry = byCountry;
  factory _StationPopularityDto.fromJson(Map<String, dynamic> json) => _$StationPopularityDtoFromJson(json);

@override final  int? global;
 final  Map<String, int>? _byCountry;
@override Map<String, int>? get byCountry {
  final value = _byCountry;
  if (value == null) return null;
  if (_byCountry is EqualUnmodifiableMapView) return _byCountry;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of StationPopularityDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StationPopularityDtoCopyWith<_StationPopularityDto> get copyWith => __$StationPopularityDtoCopyWithImpl<_StationPopularityDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StationPopularityDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StationPopularityDto&&(identical(other.global, global) || other.global == global)&&const DeepCollectionEquality().equals(other._byCountry, _byCountry));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,global,const DeepCollectionEquality().hash(_byCountry));

@override
String toString() {
  return 'StationPopularityDto(global: $global, byCountry: $byCountry)';
}


}

/// @nodoc
abstract mixin class _$StationPopularityDtoCopyWith<$Res> implements $StationPopularityDtoCopyWith<$Res> {
  factory _$StationPopularityDtoCopyWith(_StationPopularityDto value, $Res Function(_StationPopularityDto) _then) = __$StationPopularityDtoCopyWithImpl;
@override @useResult
$Res call({
 int? global, Map<String, int>? byCountry
});




}
/// @nodoc
class __$StationPopularityDtoCopyWithImpl<$Res>
    implements _$StationPopularityDtoCopyWith<$Res> {
  __$StationPopularityDtoCopyWithImpl(this._self, this._then);

  final _StationPopularityDto _self;
  final $Res Function(_StationPopularityDto) _then;

/// Create a copy of StationPopularityDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? global = freezed,Object? byCountry = freezed,}) {
  return _then(_StationPopularityDto(
global: freezed == global ? _self.global : global // ignore: cast_nullable_to_non_nullable
as int?,byCountry: freezed == byCountry ? _self._byCountry : byCountry // ignore: cast_nullable_to_non_nullable
as Map<String, int>?,
  ));
}


}

// dart format on
