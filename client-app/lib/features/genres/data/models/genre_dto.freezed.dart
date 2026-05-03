// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'genre_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GenreDto {

 int get id; String? get slug; String? get name; int? get radioCount;
/// Create a copy of GenreDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenreDtoCopyWith<GenreDto> get copyWith => _$GenreDtoCopyWithImpl<GenreDto>(this as GenreDto, _$identity);

  /// Serializes this GenreDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenreDto&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.radioCount, radioCount) || other.radioCount == radioCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,name,radioCount);

@override
String toString() {
  return 'GenreDto(id: $id, slug: $slug, name: $name, radioCount: $radioCount)';
}


}

/// @nodoc
abstract mixin class $GenreDtoCopyWith<$Res>  {
  factory $GenreDtoCopyWith(GenreDto value, $Res Function(GenreDto) _then) = _$GenreDtoCopyWithImpl;
@useResult
$Res call({
 int id, String? slug, String? name, int? radioCount
});




}
/// @nodoc
class _$GenreDtoCopyWithImpl<$Res>
    implements $GenreDtoCopyWith<$Res> {
  _$GenreDtoCopyWithImpl(this._self, this._then);

  final GenreDto _self;
  final $Res Function(GenreDto) _then;

/// Create a copy of GenreDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = freezed,Object? name = freezed,Object? radioCount = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,radioCount: freezed == radioCount ? _self.radioCount : radioCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [GenreDto].
extension GenreDtoPatterns on GenreDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GenreDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GenreDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GenreDto value)  $default,){
final _that = this;
switch (_that) {
case _GenreDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GenreDto value)?  $default,){
final _that = this;
switch (_that) {
case _GenreDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? slug,  String? name,  int? radioCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GenreDto() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.radioCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? slug,  String? name,  int? radioCount)  $default,) {final _that = this;
switch (_that) {
case _GenreDto():
return $default(_that.id,_that.slug,_that.name,_that.radioCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? slug,  String? name,  int? radioCount)?  $default,) {final _that = this;
switch (_that) {
case _GenreDto() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.radioCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GenreDto implements GenreDto {
  const _GenreDto({required this.id, this.slug, this.name, this.radioCount});
  factory _GenreDto.fromJson(Map<String, dynamic> json) => _$GenreDtoFromJson(json);

@override final  int id;
@override final  String? slug;
@override final  String? name;
@override final  int? radioCount;

/// Create a copy of GenreDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenreDtoCopyWith<_GenreDto> get copyWith => __$GenreDtoCopyWithImpl<_GenreDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GenreDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenreDto&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.radioCount, radioCount) || other.radioCount == radioCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,name,radioCount);

@override
String toString() {
  return 'GenreDto(id: $id, slug: $slug, name: $name, radioCount: $radioCount)';
}


}

/// @nodoc
abstract mixin class _$GenreDtoCopyWith<$Res> implements $GenreDtoCopyWith<$Res> {
  factory _$GenreDtoCopyWith(_GenreDto value, $Res Function(_GenreDto) _then) = __$GenreDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String? slug, String? name, int? radioCount
});




}
/// @nodoc
class __$GenreDtoCopyWithImpl<$Res>
    implements _$GenreDtoCopyWith<$Res> {
  __$GenreDtoCopyWithImpl(this._self, this._then);

  final _GenreDto _self;
  final $Res Function(_GenreDto) _then;

/// Create a copy of GenreDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = freezed,Object? name = freezed,Object? radioCount = freezed,}) {
  return _then(_GenreDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,radioCount: freezed == radioCount ? _self.radioCount : radioCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
