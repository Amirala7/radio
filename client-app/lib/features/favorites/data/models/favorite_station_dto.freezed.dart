// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_station_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FavoriteStationDto {

 StationDto get station; Timestamp get addedAt;
/// Create a copy of FavoriteStationDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoriteStationDtoCopyWith<FavoriteStationDto> get copyWith => _$FavoriteStationDtoCopyWithImpl<FavoriteStationDto>(this as FavoriteStationDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteStationDto&&(identical(other.station, station) || other.station == station)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt));
}


@override
int get hashCode => Object.hash(runtimeType,station,addedAt);

@override
String toString() {
  return 'FavoriteStationDto(station: $station, addedAt: $addedAt)';
}


}

/// @nodoc
abstract mixin class $FavoriteStationDtoCopyWith<$Res>  {
  factory $FavoriteStationDtoCopyWith(FavoriteStationDto value, $Res Function(FavoriteStationDto) _then) = _$FavoriteStationDtoCopyWithImpl;
@useResult
$Res call({
 StationDto station, Timestamp addedAt
});


$StationDtoCopyWith<$Res> get station;

}
/// @nodoc
class _$FavoriteStationDtoCopyWithImpl<$Res>
    implements $FavoriteStationDtoCopyWith<$Res> {
  _$FavoriteStationDtoCopyWithImpl(this._self, this._then);

  final FavoriteStationDto _self;
  final $Res Function(FavoriteStationDto) _then;

/// Create a copy of FavoriteStationDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? station = null,Object? addedAt = null,}) {
  return _then(_self.copyWith(
station: null == station ? _self.station : station // ignore: cast_nullable_to_non_nullable
as StationDto,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as Timestamp,
  ));
}
/// Create a copy of FavoriteStationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationDtoCopyWith<$Res> get station {
  
  return $StationDtoCopyWith<$Res>(_self.station, (value) {
    return _then(_self.copyWith(station: value));
  });
}
}


/// Adds pattern-matching-related methods to [FavoriteStationDto].
extension FavoriteStationDtoPatterns on FavoriteStationDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FavoriteStationDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FavoriteStationDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FavoriteStationDto value)  $default,){
final _that = this;
switch (_that) {
case _FavoriteStationDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FavoriteStationDto value)?  $default,){
final _that = this;
switch (_that) {
case _FavoriteStationDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StationDto station,  Timestamp addedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FavoriteStationDto() when $default != null:
return $default(_that.station,_that.addedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StationDto station,  Timestamp addedAt)  $default,) {final _that = this;
switch (_that) {
case _FavoriteStationDto():
return $default(_that.station,_that.addedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StationDto station,  Timestamp addedAt)?  $default,) {final _that = this;
switch (_that) {
case _FavoriteStationDto() when $default != null:
return $default(_that.station,_that.addedAt);case _:
  return null;

}
}

}

/// @nodoc


class _FavoriteStationDto implements FavoriteStationDto {
  const _FavoriteStationDto({required this.station, required this.addedAt});
  

@override final  StationDto station;
@override final  Timestamp addedAt;

/// Create a copy of FavoriteStationDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FavoriteStationDtoCopyWith<_FavoriteStationDto> get copyWith => __$FavoriteStationDtoCopyWithImpl<_FavoriteStationDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FavoriteStationDto&&(identical(other.station, station) || other.station == station)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt));
}


@override
int get hashCode => Object.hash(runtimeType,station,addedAt);

@override
String toString() {
  return 'FavoriteStationDto(station: $station, addedAt: $addedAt)';
}


}

/// @nodoc
abstract mixin class _$FavoriteStationDtoCopyWith<$Res> implements $FavoriteStationDtoCopyWith<$Res> {
  factory _$FavoriteStationDtoCopyWith(_FavoriteStationDto value, $Res Function(_FavoriteStationDto) _then) = __$FavoriteStationDtoCopyWithImpl;
@override @useResult
$Res call({
 StationDto station, Timestamp addedAt
});


@override $StationDtoCopyWith<$Res> get station;

}
/// @nodoc
class __$FavoriteStationDtoCopyWithImpl<$Res>
    implements _$FavoriteStationDtoCopyWith<$Res> {
  __$FavoriteStationDtoCopyWithImpl(this._self, this._then);

  final _FavoriteStationDto _self;
  final $Res Function(_FavoriteStationDto) _then;

/// Create a copy of FavoriteStationDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? station = null,Object? addedAt = null,}) {
  return _then(_FavoriteStationDto(
station: null == station ? _self.station : station // ignore: cast_nullable_to_non_nullable
as StationDto,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as Timestamp,
  ));
}

/// Create a copy of FavoriteStationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationDtoCopyWith<$Res> get station {
  
  return $StationDtoCopyWith<$Res>(_self.station, (value) {
    return _then(_self.copyWith(station: value));
  });
}
}

// dart format on
