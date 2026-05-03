// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'station_aliases_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StationAliasesDto {

 String? get cleanName; String? get alsoKnownAs;
/// Create a copy of StationAliasesDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StationAliasesDtoCopyWith<StationAliasesDto> get copyWith => _$StationAliasesDtoCopyWithImpl<StationAliasesDto>(this as StationAliasesDto, _$identity);

  /// Serializes this StationAliasesDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StationAliasesDto&&(identical(other.cleanName, cleanName) || other.cleanName == cleanName)&&(identical(other.alsoKnownAs, alsoKnownAs) || other.alsoKnownAs == alsoKnownAs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cleanName,alsoKnownAs);

@override
String toString() {
  return 'StationAliasesDto(cleanName: $cleanName, alsoKnownAs: $alsoKnownAs)';
}


}

/// @nodoc
abstract mixin class $StationAliasesDtoCopyWith<$Res>  {
  factory $StationAliasesDtoCopyWith(StationAliasesDto value, $Res Function(StationAliasesDto) _then) = _$StationAliasesDtoCopyWithImpl;
@useResult
$Res call({
 String? cleanName, String? alsoKnownAs
});




}
/// @nodoc
class _$StationAliasesDtoCopyWithImpl<$Res>
    implements $StationAliasesDtoCopyWith<$Res> {
  _$StationAliasesDtoCopyWithImpl(this._self, this._then);

  final StationAliasesDto _self;
  final $Res Function(StationAliasesDto) _then;

/// Create a copy of StationAliasesDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cleanName = freezed,Object? alsoKnownAs = freezed,}) {
  return _then(_self.copyWith(
cleanName: freezed == cleanName ? _self.cleanName : cleanName // ignore: cast_nullable_to_non_nullable
as String?,alsoKnownAs: freezed == alsoKnownAs ? _self.alsoKnownAs : alsoKnownAs // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StationAliasesDto].
extension StationAliasesDtoPatterns on StationAliasesDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StationAliasesDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StationAliasesDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StationAliasesDto value)  $default,){
final _that = this;
switch (_that) {
case _StationAliasesDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StationAliasesDto value)?  $default,){
final _that = this;
switch (_that) {
case _StationAliasesDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? cleanName,  String? alsoKnownAs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StationAliasesDto() when $default != null:
return $default(_that.cleanName,_that.alsoKnownAs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? cleanName,  String? alsoKnownAs)  $default,) {final _that = this;
switch (_that) {
case _StationAliasesDto():
return $default(_that.cleanName,_that.alsoKnownAs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? cleanName,  String? alsoKnownAs)?  $default,) {final _that = this;
switch (_that) {
case _StationAliasesDto() when $default != null:
return $default(_that.cleanName,_that.alsoKnownAs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StationAliasesDto implements StationAliasesDto {
  const _StationAliasesDto({this.cleanName, this.alsoKnownAs});
  factory _StationAliasesDto.fromJson(Map<String, dynamic> json) => _$StationAliasesDtoFromJson(json);

@override final  String? cleanName;
@override final  String? alsoKnownAs;

/// Create a copy of StationAliasesDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StationAliasesDtoCopyWith<_StationAliasesDto> get copyWith => __$StationAliasesDtoCopyWithImpl<_StationAliasesDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StationAliasesDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StationAliasesDto&&(identical(other.cleanName, cleanName) || other.cleanName == cleanName)&&(identical(other.alsoKnownAs, alsoKnownAs) || other.alsoKnownAs == alsoKnownAs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cleanName,alsoKnownAs);

@override
String toString() {
  return 'StationAliasesDto(cleanName: $cleanName, alsoKnownAs: $alsoKnownAs)';
}


}

/// @nodoc
abstract mixin class _$StationAliasesDtoCopyWith<$Res> implements $StationAliasesDtoCopyWith<$Res> {
  factory _$StationAliasesDtoCopyWith(_StationAliasesDto value, $Res Function(_StationAliasesDto) _then) = __$StationAliasesDtoCopyWithImpl;
@override @useResult
$Res call({
 String? cleanName, String? alsoKnownAs
});




}
/// @nodoc
class __$StationAliasesDtoCopyWithImpl<$Res>
    implements _$StationAliasesDtoCopyWith<$Res> {
  __$StationAliasesDtoCopyWithImpl(this._self, this._then);

  final _StationAliasesDto _self;
  final $Res Function(_StationAliasesDto) _then;

/// Create a copy of StationAliasesDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cleanName = freezed,Object? alsoKnownAs = freezed,}) {
  return _then(_StationAliasesDto(
cleanName: freezed == cleanName ? _self.cleanName : cleanName // ignore: cast_nullable_to_non_nullable
as String?,alsoKnownAs: freezed == alsoKnownAs ? _self.alsoKnownAs : alsoKnownAs // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
