// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'station_dial_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StationDialDto {

 String? get band; String? get dial; String? get dialStripped;
/// Create a copy of StationDialDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StationDialDtoCopyWith<StationDialDto> get copyWith => _$StationDialDtoCopyWithImpl<StationDialDto>(this as StationDialDto, _$identity);

  /// Serializes this StationDialDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StationDialDto&&(identical(other.band, band) || other.band == band)&&(identical(other.dial, dial) || other.dial == dial)&&(identical(other.dialStripped, dialStripped) || other.dialStripped == dialStripped));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,band,dial,dialStripped);

@override
String toString() {
  return 'StationDialDto(band: $band, dial: $dial, dialStripped: $dialStripped)';
}


}

/// @nodoc
abstract mixin class $StationDialDtoCopyWith<$Res>  {
  factory $StationDialDtoCopyWith(StationDialDto value, $Res Function(StationDialDto) _then) = _$StationDialDtoCopyWithImpl;
@useResult
$Res call({
 String? band, String? dial, String? dialStripped
});




}
/// @nodoc
class _$StationDialDtoCopyWithImpl<$Res>
    implements $StationDialDtoCopyWith<$Res> {
  _$StationDialDtoCopyWithImpl(this._self, this._then);

  final StationDialDto _self;
  final $Res Function(StationDialDto) _then;

/// Create a copy of StationDialDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? band = freezed,Object? dial = freezed,Object? dialStripped = freezed,}) {
  return _then(_self.copyWith(
band: freezed == band ? _self.band : band // ignore: cast_nullable_to_non_nullable
as String?,dial: freezed == dial ? _self.dial : dial // ignore: cast_nullable_to_non_nullable
as String?,dialStripped: freezed == dialStripped ? _self.dialStripped : dialStripped // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StationDialDto].
extension StationDialDtoPatterns on StationDialDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StationDialDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StationDialDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StationDialDto value)  $default,){
final _that = this;
switch (_that) {
case _StationDialDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StationDialDto value)?  $default,){
final _that = this;
switch (_that) {
case _StationDialDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? band,  String? dial,  String? dialStripped)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StationDialDto() when $default != null:
return $default(_that.band,_that.dial,_that.dialStripped);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? band,  String? dial,  String? dialStripped)  $default,) {final _that = this;
switch (_that) {
case _StationDialDto():
return $default(_that.band,_that.dial,_that.dialStripped);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? band,  String? dial,  String? dialStripped)?  $default,) {final _that = this;
switch (_that) {
case _StationDialDto() when $default != null:
return $default(_that.band,_that.dial,_that.dialStripped);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StationDialDto implements StationDialDto {
  const _StationDialDto({this.band, this.dial, this.dialStripped});
  factory _StationDialDto.fromJson(Map<String, dynamic> json) => _$StationDialDtoFromJson(json);

@override final  String? band;
@override final  String? dial;
@override final  String? dialStripped;

/// Create a copy of StationDialDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StationDialDtoCopyWith<_StationDialDto> get copyWith => __$StationDialDtoCopyWithImpl<_StationDialDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StationDialDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StationDialDto&&(identical(other.band, band) || other.band == band)&&(identical(other.dial, dial) || other.dial == dial)&&(identical(other.dialStripped, dialStripped) || other.dialStripped == dialStripped));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,band,dial,dialStripped);

@override
String toString() {
  return 'StationDialDto(band: $band, dial: $dial, dialStripped: $dialStripped)';
}


}

/// @nodoc
abstract mixin class _$StationDialDtoCopyWith<$Res> implements $StationDialDtoCopyWith<$Res> {
  factory _$StationDialDtoCopyWith(_StationDialDto value, $Res Function(_StationDialDto) _then) = __$StationDialDtoCopyWithImpl;
@override @useResult
$Res call({
 String? band, String? dial, String? dialStripped
});




}
/// @nodoc
class __$StationDialDtoCopyWithImpl<$Res>
    implements _$StationDialDtoCopyWith<$Res> {
  __$StationDialDtoCopyWithImpl(this._self, this._then);

  final _StationDialDto _self;
  final $Res Function(_StationDialDto) _then;

/// Create a copy of StationDialDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? band = freezed,Object? dial = freezed,Object? dialStripped = freezed,}) {
  return _then(_StationDialDto(
band: freezed == band ? _self.band : band // ignore: cast_nullable_to_non_nullable
as String?,dial: freezed == dial ? _self.dial : dial // ignore: cast_nullable_to_non_nullable
as String?,dialStripped: freezed == dialStripped ? _self.dialStripped : dialStripped // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
