// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_station.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FavoriteStation {

 Station get station; DateTime get addedAt;
/// Create a copy of FavoriteStation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoriteStationCopyWith<FavoriteStation> get copyWith => _$FavoriteStationCopyWithImpl<FavoriteStation>(this as FavoriteStation, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteStation&&(identical(other.station, station) || other.station == station)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt));
}


@override
int get hashCode => Object.hash(runtimeType,station,addedAt);

@override
String toString() {
  return 'FavoriteStation(station: $station, addedAt: $addedAt)';
}


}

/// @nodoc
abstract mixin class $FavoriteStationCopyWith<$Res>  {
  factory $FavoriteStationCopyWith(FavoriteStation value, $Res Function(FavoriteStation) _then) = _$FavoriteStationCopyWithImpl;
@useResult
$Res call({
 Station station, DateTime addedAt
});


$StationCopyWith<$Res> get station;

}
/// @nodoc
class _$FavoriteStationCopyWithImpl<$Res>
    implements $FavoriteStationCopyWith<$Res> {
  _$FavoriteStationCopyWithImpl(this._self, this._then);

  final FavoriteStation _self;
  final $Res Function(FavoriteStation) _then;

/// Create a copy of FavoriteStation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? station = null,Object? addedAt = null,}) {
  return _then(_self.copyWith(
station: null == station ? _self.station : station // ignore: cast_nullable_to_non_nullable
as Station,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of FavoriteStation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationCopyWith<$Res> get station {
  
  return $StationCopyWith<$Res>(_self.station, (value) {
    return _then(_self.copyWith(station: value));
  });
}
}


/// Adds pattern-matching-related methods to [FavoriteStation].
extension FavoriteStationPatterns on FavoriteStation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FavoriteStation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FavoriteStation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FavoriteStation value)  $default,){
final _that = this;
switch (_that) {
case _FavoriteStation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FavoriteStation value)?  $default,){
final _that = this;
switch (_that) {
case _FavoriteStation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Station station,  DateTime addedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FavoriteStation() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Station station,  DateTime addedAt)  $default,) {final _that = this;
switch (_that) {
case _FavoriteStation():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Station station,  DateTime addedAt)?  $default,) {final _that = this;
switch (_that) {
case _FavoriteStation() when $default != null:
return $default(_that.station,_that.addedAt);case _:
  return null;

}
}

}

/// @nodoc


class _FavoriteStation implements FavoriteStation {
  const _FavoriteStation({required this.station, required this.addedAt});
  

@override final  Station station;
@override final  DateTime addedAt;

/// Create a copy of FavoriteStation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FavoriteStationCopyWith<_FavoriteStation> get copyWith => __$FavoriteStationCopyWithImpl<_FavoriteStation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FavoriteStation&&(identical(other.station, station) || other.station == station)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt));
}


@override
int get hashCode => Object.hash(runtimeType,station,addedAt);

@override
String toString() {
  return 'FavoriteStation(station: $station, addedAt: $addedAt)';
}


}

/// @nodoc
abstract mixin class _$FavoriteStationCopyWith<$Res> implements $FavoriteStationCopyWith<$Res> {
  factory _$FavoriteStationCopyWith(_FavoriteStation value, $Res Function(_FavoriteStation) _then) = __$FavoriteStationCopyWithImpl;
@override @useResult
$Res call({
 Station station, DateTime addedAt
});


@override $StationCopyWith<$Res> get station;

}
/// @nodoc
class __$FavoriteStationCopyWithImpl<$Res>
    implements _$FavoriteStationCopyWith<$Res> {
  __$FavoriteStationCopyWithImpl(this._self, this._then);

  final _FavoriteStation _self;
  final $Res Function(_FavoriteStation) _then;

/// Create a copy of FavoriteStation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? station = null,Object? addedAt = null,}) {
  return _then(_FavoriteStation(
station: null == station ? _self.station : station // ignore: cast_nullable_to_non_nullable
as Station,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of FavoriteStation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationCopyWith<$Res> get station {
  
  return $StationCopyWith<$Res>(_self.station, (value) {
    return _then(_self.copyWith(station: value));
  });
}
}

// dart format on
