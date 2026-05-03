// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'station_location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StationLocation {

 int? get cityId; String? get cityName; String? get countryName; String? get countryCode; String? get locationText; Coordinates? get coordinates;
/// Create a copy of StationLocation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StationLocationCopyWith<StationLocation> get copyWith => _$StationLocationCopyWithImpl<StationLocation>(this as StationLocation, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StationLocation&&(identical(other.cityId, cityId) || other.cityId == cityId)&&(identical(other.cityName, cityName) || other.cityName == cityName)&&(identical(other.countryName, countryName) || other.countryName == countryName)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.locationText, locationText) || other.locationText == locationText)&&(identical(other.coordinates, coordinates) || other.coordinates == coordinates));
}


@override
int get hashCode => Object.hash(runtimeType,cityId,cityName,countryName,countryCode,locationText,coordinates);

@override
String toString() {
  return 'StationLocation(cityId: $cityId, cityName: $cityName, countryName: $countryName, countryCode: $countryCode, locationText: $locationText, coordinates: $coordinates)';
}


}

/// @nodoc
abstract mixin class $StationLocationCopyWith<$Res>  {
  factory $StationLocationCopyWith(StationLocation value, $Res Function(StationLocation) _then) = _$StationLocationCopyWithImpl;
@useResult
$Res call({
 int? cityId, String? cityName, String? countryName, String? countryCode, String? locationText, Coordinates? coordinates
});


$CoordinatesCopyWith<$Res>? get coordinates;

}
/// @nodoc
class _$StationLocationCopyWithImpl<$Res>
    implements $StationLocationCopyWith<$Res> {
  _$StationLocationCopyWithImpl(this._self, this._then);

  final StationLocation _self;
  final $Res Function(StationLocation) _then;

/// Create a copy of StationLocation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cityId = freezed,Object? cityName = freezed,Object? countryName = freezed,Object? countryCode = freezed,Object? locationText = freezed,Object? coordinates = freezed,}) {
  return _then(_self.copyWith(
cityId: freezed == cityId ? _self.cityId : cityId // ignore: cast_nullable_to_non_nullable
as int?,cityName: freezed == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String?,countryName: freezed == countryName ? _self.countryName : countryName // ignore: cast_nullable_to_non_nullable
as String?,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,locationText: freezed == locationText ? _self.locationText : locationText // ignore: cast_nullable_to_non_nullable
as String?,coordinates: freezed == coordinates ? _self.coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as Coordinates?,
  ));
}
/// Create a copy of StationLocation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoordinatesCopyWith<$Res>? get coordinates {
    if (_self.coordinates == null) {
    return null;
  }

  return $CoordinatesCopyWith<$Res>(_self.coordinates!, (value) {
    return _then(_self.copyWith(coordinates: value));
  });
}
}


/// Adds pattern-matching-related methods to [StationLocation].
extension StationLocationPatterns on StationLocation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StationLocation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StationLocation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StationLocation value)  $default,){
final _that = this;
switch (_that) {
case _StationLocation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StationLocation value)?  $default,){
final _that = this;
switch (_that) {
case _StationLocation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? cityId,  String? cityName,  String? countryName,  String? countryCode,  String? locationText,  Coordinates? coordinates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StationLocation() when $default != null:
return $default(_that.cityId,_that.cityName,_that.countryName,_that.countryCode,_that.locationText,_that.coordinates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? cityId,  String? cityName,  String? countryName,  String? countryCode,  String? locationText,  Coordinates? coordinates)  $default,) {final _that = this;
switch (_that) {
case _StationLocation():
return $default(_that.cityId,_that.cityName,_that.countryName,_that.countryCode,_that.locationText,_that.coordinates);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? cityId,  String? cityName,  String? countryName,  String? countryCode,  String? locationText,  Coordinates? coordinates)?  $default,) {final _that = this;
switch (_that) {
case _StationLocation() when $default != null:
return $default(_that.cityId,_that.cityName,_that.countryName,_that.countryCode,_that.locationText,_that.coordinates);case _:
  return null;

}
}

}

/// @nodoc


class _StationLocation implements StationLocation {
  const _StationLocation({this.cityId, this.cityName, this.countryName, this.countryCode, this.locationText, this.coordinates});
  

@override final  int? cityId;
@override final  String? cityName;
@override final  String? countryName;
@override final  String? countryCode;
@override final  String? locationText;
@override final  Coordinates? coordinates;

/// Create a copy of StationLocation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StationLocationCopyWith<_StationLocation> get copyWith => __$StationLocationCopyWithImpl<_StationLocation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StationLocation&&(identical(other.cityId, cityId) || other.cityId == cityId)&&(identical(other.cityName, cityName) || other.cityName == cityName)&&(identical(other.countryName, countryName) || other.countryName == countryName)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.locationText, locationText) || other.locationText == locationText)&&(identical(other.coordinates, coordinates) || other.coordinates == coordinates));
}


@override
int get hashCode => Object.hash(runtimeType,cityId,cityName,countryName,countryCode,locationText,coordinates);

@override
String toString() {
  return 'StationLocation(cityId: $cityId, cityName: $cityName, countryName: $countryName, countryCode: $countryCode, locationText: $locationText, coordinates: $coordinates)';
}


}

/// @nodoc
abstract mixin class _$StationLocationCopyWith<$Res> implements $StationLocationCopyWith<$Res> {
  factory _$StationLocationCopyWith(_StationLocation value, $Res Function(_StationLocation) _then) = __$StationLocationCopyWithImpl;
@override @useResult
$Res call({
 int? cityId, String? cityName, String? countryName, String? countryCode, String? locationText, Coordinates? coordinates
});


@override $CoordinatesCopyWith<$Res>? get coordinates;

}
/// @nodoc
class __$StationLocationCopyWithImpl<$Res>
    implements _$StationLocationCopyWith<$Res> {
  __$StationLocationCopyWithImpl(this._self, this._then);

  final _StationLocation _self;
  final $Res Function(_StationLocation) _then;

/// Create a copy of StationLocation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cityId = freezed,Object? cityName = freezed,Object? countryName = freezed,Object? countryCode = freezed,Object? locationText = freezed,Object? coordinates = freezed,}) {
  return _then(_StationLocation(
cityId: freezed == cityId ? _self.cityId : cityId // ignore: cast_nullable_to_non_nullable
as int?,cityName: freezed == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String?,countryName: freezed == countryName ? _self.countryName : countryName // ignore: cast_nullable_to_non_nullable
as String?,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,locationText: freezed == locationText ? _self.locationText : locationText // ignore: cast_nullable_to_non_nullable
as String?,coordinates: freezed == coordinates ? _self.coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as Coordinates?,
  ));
}

/// Create a copy of StationLocation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoordinatesCopyWith<$Res>? get coordinates {
    if (_self.coordinates == null) {
    return null;
  }

  return $CoordinatesCopyWith<$Res>(_self.coordinates!, (value) {
    return _then(_self.copyWith(coordinates: value));
  });
}
}

// dart format on
