// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'station_language_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StationLanguageDto {

 String get code; String? get name;
/// Create a copy of StationLanguageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StationLanguageDtoCopyWith<StationLanguageDto> get copyWith => _$StationLanguageDtoCopyWithImpl<StationLanguageDto>(this as StationLanguageDto, _$identity);

  /// Serializes this StationLanguageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StationLanguageDto&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,name);

@override
String toString() {
  return 'StationLanguageDto(code: $code, name: $name)';
}


}

/// @nodoc
abstract mixin class $StationLanguageDtoCopyWith<$Res>  {
  factory $StationLanguageDtoCopyWith(StationLanguageDto value, $Res Function(StationLanguageDto) _then) = _$StationLanguageDtoCopyWithImpl;
@useResult
$Res call({
 String code, String? name
});




}
/// @nodoc
class _$StationLanguageDtoCopyWithImpl<$Res>
    implements $StationLanguageDtoCopyWith<$Res> {
  _$StationLanguageDtoCopyWithImpl(this._self, this._then);

  final StationLanguageDto _self;
  final $Res Function(StationLanguageDto) _then;

/// Create a copy of StationLanguageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? name = freezed,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StationLanguageDto].
extension StationLanguageDtoPatterns on StationLanguageDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StationLanguageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StationLanguageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StationLanguageDto value)  $default,){
final _that = this;
switch (_that) {
case _StationLanguageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StationLanguageDto value)?  $default,){
final _that = this;
switch (_that) {
case _StationLanguageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String? name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StationLanguageDto() when $default != null:
return $default(_that.code,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String? name)  $default,) {final _that = this;
switch (_that) {
case _StationLanguageDto():
return $default(_that.code,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String? name)?  $default,) {final _that = this;
switch (_that) {
case _StationLanguageDto() when $default != null:
return $default(_that.code,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StationLanguageDto implements StationLanguageDto {
  const _StationLanguageDto({required this.code, this.name});
  factory _StationLanguageDto.fromJson(Map<String, dynamic> json) => _$StationLanguageDtoFromJson(json);

@override final  String code;
@override final  String? name;

/// Create a copy of StationLanguageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StationLanguageDtoCopyWith<_StationLanguageDto> get copyWith => __$StationLanguageDtoCopyWithImpl<_StationLanguageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StationLanguageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StationLanguageDto&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,name);

@override
String toString() {
  return 'StationLanguageDto(code: $code, name: $name)';
}


}

/// @nodoc
abstract mixin class _$StationLanguageDtoCopyWith<$Res> implements $StationLanguageDtoCopyWith<$Res> {
  factory _$StationLanguageDtoCopyWith(_StationLanguageDto value, $Res Function(_StationLanguageDto) _then) = __$StationLanguageDtoCopyWithImpl;
@override @useResult
$Res call({
 String code, String? name
});




}
/// @nodoc
class __$StationLanguageDtoCopyWithImpl<$Res>
    implements _$StationLanguageDtoCopyWith<$Res> {
  __$StationLanguageDtoCopyWithImpl(this._self, this._then);

  final _StationLanguageDto _self;
  final $Res Function(_StationLanguageDto) _then;

/// Create a copy of StationLanguageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? name = freezed,}) {
  return _then(_StationLanguageDto(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
