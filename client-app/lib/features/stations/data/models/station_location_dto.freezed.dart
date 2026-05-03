// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'station_location_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StationLocationDto {

 int? get cityId; String? get cityName; String? get countryName; String? get countryCode; String? get locationText; CoordinatesDto? get coordinates;
/// Create a copy of StationLocationDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StationLocationDtoCopyWith<StationLocationDto> get copyWith => _$StationLocationDtoCopyWithImpl<StationLocationDto>(this as StationLocationDto, _$identity);

  /// Serializes this StationLocationDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StationLocationDto&&(identical(other.cityId, cityId) || other.cityId == cityId)&&(identical(other.cityName, cityName) || other.cityName == cityName)&&(identical(other.countryName, countryName) || other.countryName == countryName)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.locationText, locationText) || other.locationText == locationText)&&(identical(other.coordinates, coordinates) || other.coordinates == coordinates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cityId,cityName,countryName,countryCode,locationText,coordinates);

@override
String toString() {
  return 'StationLocationDto(cityId: $cityId, cityName: $cityName, countryName: $countryName, countryCode: $countryCode, locationText: $locationText, coordinates: $coordinates)';
}


}

/// @nodoc
abstract mixin class $StationLocationDtoCopyWith<$Res>  {
  factory $StationLocationDtoCopyWith(StationLocationDto value, $Res Function(StationLocationDto) _then) = _$StationLocationDtoCopyWithImpl;
@useResult
$Res call({
 int? cityId, String? cityName, String? countryName, String? countryCode, String? locationText, CoordinatesDto? coordinates
});


$CoordinatesDtoCopyWith<$Res>? get coordinates;

}
/// @nodoc
class _$StationLocationDtoCopyWithImpl<$Res>
    implements $StationLocationDtoCopyWith<$Res> {
  _$StationLocationDtoCopyWithImpl(this._self, this._then);

  final StationLocationDto _self;
  final $Res Function(StationLocationDto) _then;

/// Create a copy of StationLocationDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cityId = freezed,Object? cityName = freezed,Object? countryName = freezed,Object? countryCode = freezed,Object? locationText = freezed,Object? coordinates = freezed,}) {
  return _then(_self.copyWith(
cityId: freezed == cityId ? _self.cityId : cityId // ignore: cast_nullable_to_non_nullable
as int?,cityName: freezed == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String?,countryName: freezed == countryName ? _self.countryName : countryName // ignore: cast_nullable_to_non_nullable
as String?,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,locationText: freezed == locationText ? _self.locationText : locationText // ignore: cast_nullable_to_non_nullable
as String?,coordinates: freezed == coordinates ? _self.coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as CoordinatesDto?,
  ));
}
/// Create a copy of StationLocationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoordinatesDtoCopyWith<$Res>? get coordinates {
    if (_self.coordinates == null) {
    return null;
  }

  return $CoordinatesDtoCopyWith<$Res>(_self.coordinates!, (value) {
    return _then(_self.copyWith(coordinates: value));
  });
}
}


/// Adds pattern-matching-related methods to [StationLocationDto].
extension StationLocationDtoPatterns on StationLocationDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StationLocationDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StationLocationDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StationLocationDto value)  $default,){
final _that = this;
switch (_that) {
case _StationLocationDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StationLocationDto value)?  $default,){
final _that = this;
switch (_that) {
case _StationLocationDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? cityId,  String? cityName,  String? countryName,  String? countryCode,  String? locationText,  CoordinatesDto? coordinates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StationLocationDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? cityId,  String? cityName,  String? countryName,  String? countryCode,  String? locationText,  CoordinatesDto? coordinates)  $default,) {final _that = this;
switch (_that) {
case _StationLocationDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? cityId,  String? cityName,  String? countryName,  String? countryCode,  String? locationText,  CoordinatesDto? coordinates)?  $default,) {final _that = this;
switch (_that) {
case _StationLocationDto() when $default != null:
return $default(_that.cityId,_that.cityName,_that.countryName,_that.countryCode,_that.locationText,_that.coordinates);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StationLocationDto implements StationLocationDto {
  const _StationLocationDto({this.cityId, this.cityName, this.countryName, this.countryCode, this.locationText, this.coordinates});
  factory _StationLocationDto.fromJson(Map<String, dynamic> json) => _$StationLocationDtoFromJson(json);

@override final  int? cityId;
@override final  String? cityName;
@override final  String? countryName;
@override final  String? countryCode;
@override final  String? locationText;
@override final  CoordinatesDto? coordinates;

/// Create a copy of StationLocationDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StationLocationDtoCopyWith<_StationLocationDto> get copyWith => __$StationLocationDtoCopyWithImpl<_StationLocationDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StationLocationDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StationLocationDto&&(identical(other.cityId, cityId) || other.cityId == cityId)&&(identical(other.cityName, cityName) || other.cityName == cityName)&&(identical(other.countryName, countryName) || other.countryName == countryName)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.locationText, locationText) || other.locationText == locationText)&&(identical(other.coordinates, coordinates) || other.coordinates == coordinates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cityId,cityName,countryName,countryCode,locationText,coordinates);

@override
String toString() {
  return 'StationLocationDto(cityId: $cityId, cityName: $cityName, countryName: $countryName, countryCode: $countryCode, locationText: $locationText, coordinates: $coordinates)';
}


}

/// @nodoc
abstract mixin class _$StationLocationDtoCopyWith<$Res> implements $StationLocationDtoCopyWith<$Res> {
  factory _$StationLocationDtoCopyWith(_StationLocationDto value, $Res Function(_StationLocationDto) _then) = __$StationLocationDtoCopyWithImpl;
@override @useResult
$Res call({
 int? cityId, String? cityName, String? countryName, String? countryCode, String? locationText, CoordinatesDto? coordinates
});


@override $CoordinatesDtoCopyWith<$Res>? get coordinates;

}
/// @nodoc
class __$StationLocationDtoCopyWithImpl<$Res>
    implements _$StationLocationDtoCopyWith<$Res> {
  __$StationLocationDtoCopyWithImpl(this._self, this._then);

  final _StationLocationDto _self;
  final $Res Function(_StationLocationDto) _then;

/// Create a copy of StationLocationDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cityId = freezed,Object? cityName = freezed,Object? countryName = freezed,Object? countryCode = freezed,Object? locationText = freezed,Object? coordinates = freezed,}) {
  return _then(_StationLocationDto(
cityId: freezed == cityId ? _self.cityId : cityId // ignore: cast_nullable_to_non_nullable
as int?,cityName: freezed == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String?,countryName: freezed == countryName ? _self.countryName : countryName // ignore: cast_nullable_to_non_nullable
as String?,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,locationText: freezed == locationText ? _self.locationText : locationText // ignore: cast_nullable_to_non_nullable
as String?,coordinates: freezed == coordinates ? _self.coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as CoordinatesDto?,
  ));
}

/// Create a copy of StationLocationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoordinatesDtoCopyWith<$Res>? get coordinates {
    if (_self.coordinates == null) {
    return null;
  }

  return $CoordinatesDtoCopyWith<$Res>(_self.coordinates!, (value) {
    return _then(_self.copyWith(coordinates: value));
  });
}
}

// dart format on
