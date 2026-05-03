// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'station_genre.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StationGenre {

 String? get text; List<String>? get tags;
/// Create a copy of StationGenre
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StationGenreCopyWith<StationGenre> get copyWith => _$StationGenreCopyWithImpl<StationGenre>(this as StationGenre, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StationGenre&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other.tags, tags));
}


@override
int get hashCode => Object.hash(runtimeType,text,const DeepCollectionEquality().hash(tags));

@override
String toString() {
  return 'StationGenre(text: $text, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $StationGenreCopyWith<$Res>  {
  factory $StationGenreCopyWith(StationGenre value, $Res Function(StationGenre) _then) = _$StationGenreCopyWithImpl;
@useResult
$Res call({
 String? text, List<String>? tags
});




}
/// @nodoc
class _$StationGenreCopyWithImpl<$Res>
    implements $StationGenreCopyWith<$Res> {
  _$StationGenreCopyWithImpl(this._self, this._then);

  final StationGenre _self;
  final $Res Function(StationGenre) _then;

/// Create a copy of StationGenre
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = freezed,Object? tags = freezed,}) {
  return _then(_self.copyWith(
text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,tags: freezed == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [StationGenre].
extension StationGenrePatterns on StationGenre {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StationGenre value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StationGenre() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StationGenre value)  $default,){
final _that = this;
switch (_that) {
case _StationGenre():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StationGenre value)?  $default,){
final _that = this;
switch (_that) {
case _StationGenre() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? text,  List<String>? tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StationGenre() when $default != null:
return $default(_that.text,_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? text,  List<String>? tags)  $default,) {final _that = this;
switch (_that) {
case _StationGenre():
return $default(_that.text,_that.tags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? text,  List<String>? tags)?  $default,) {final _that = this;
switch (_that) {
case _StationGenre() when $default != null:
return $default(_that.text,_that.tags);case _:
  return null;

}
}

}

/// @nodoc


class _StationGenre implements StationGenre {
  const _StationGenre({this.text, final  List<String>? tags}): _tags = tags;
  

@override final  String? text;
 final  List<String>? _tags;
@override List<String>? get tags {
  final value = _tags;
  if (value == null) return null;
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of StationGenre
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StationGenreCopyWith<_StationGenre> get copyWith => __$StationGenreCopyWithImpl<_StationGenre>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StationGenre&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other._tags, _tags));
}


@override
int get hashCode => Object.hash(runtimeType,text,const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'StationGenre(text: $text, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$StationGenreCopyWith<$Res> implements $StationGenreCopyWith<$Res> {
  factory _$StationGenreCopyWith(_StationGenre value, $Res Function(_StationGenre) _then) = __$StationGenreCopyWithImpl;
@override @useResult
$Res call({
 String? text, List<String>? tags
});




}
/// @nodoc
class __$StationGenreCopyWithImpl<$Res>
    implements _$StationGenreCopyWith<$Res> {
  __$StationGenreCopyWithImpl(this._self, this._then);

  final _StationGenre _self;
  final $Res Function(_StationGenre) _then;

/// Create a copy of StationGenre
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = freezed,Object? tags = freezed,}) {
  return _then(_StationGenre(
text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,tags: freezed == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
