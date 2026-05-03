// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'station_aliases.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StationAliases {

 String? get cleanName; String? get alsoKnownAs;
/// Create a copy of StationAliases
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StationAliasesCopyWith<StationAliases> get copyWith => _$StationAliasesCopyWithImpl<StationAliases>(this as StationAliases, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StationAliases&&(identical(other.cleanName, cleanName) || other.cleanName == cleanName)&&(identical(other.alsoKnownAs, alsoKnownAs) || other.alsoKnownAs == alsoKnownAs));
}


@override
int get hashCode => Object.hash(runtimeType,cleanName,alsoKnownAs);

@override
String toString() {
  return 'StationAliases(cleanName: $cleanName, alsoKnownAs: $alsoKnownAs)';
}


}

/// @nodoc
abstract mixin class $StationAliasesCopyWith<$Res>  {
  factory $StationAliasesCopyWith(StationAliases value, $Res Function(StationAliases) _then) = _$StationAliasesCopyWithImpl;
@useResult
$Res call({
 String? cleanName, String? alsoKnownAs
});




}
/// @nodoc
class _$StationAliasesCopyWithImpl<$Res>
    implements $StationAliasesCopyWith<$Res> {
  _$StationAliasesCopyWithImpl(this._self, this._then);

  final StationAliases _self;
  final $Res Function(StationAliases) _then;

/// Create a copy of StationAliases
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cleanName = freezed,Object? alsoKnownAs = freezed,}) {
  return _then(_self.copyWith(
cleanName: freezed == cleanName ? _self.cleanName : cleanName // ignore: cast_nullable_to_non_nullable
as String?,alsoKnownAs: freezed == alsoKnownAs ? _self.alsoKnownAs : alsoKnownAs // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StationAliases].
extension StationAliasesPatterns on StationAliases {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StationAliases value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StationAliases() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StationAliases value)  $default,){
final _that = this;
switch (_that) {
case _StationAliases():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StationAliases value)?  $default,){
final _that = this;
switch (_that) {
case _StationAliases() when $default != null:
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
case _StationAliases() when $default != null:
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
case _StationAliases():
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
case _StationAliases() when $default != null:
return $default(_that.cleanName,_that.alsoKnownAs);case _:
  return null;

}
}

}

/// @nodoc


class _StationAliases implements StationAliases {
  const _StationAliases({this.cleanName, this.alsoKnownAs});
  

@override final  String? cleanName;
@override final  String? alsoKnownAs;

/// Create a copy of StationAliases
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StationAliasesCopyWith<_StationAliases> get copyWith => __$StationAliasesCopyWithImpl<_StationAliases>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StationAliases&&(identical(other.cleanName, cleanName) || other.cleanName == cleanName)&&(identical(other.alsoKnownAs, alsoKnownAs) || other.alsoKnownAs == alsoKnownAs));
}


@override
int get hashCode => Object.hash(runtimeType,cleanName,alsoKnownAs);

@override
String toString() {
  return 'StationAliases(cleanName: $cleanName, alsoKnownAs: $alsoKnownAs)';
}


}

/// @nodoc
abstract mixin class _$StationAliasesCopyWith<$Res> implements $StationAliasesCopyWith<$Res> {
  factory _$StationAliasesCopyWith(_StationAliases value, $Res Function(_StationAliases) _then) = __$StationAliasesCopyWithImpl;
@override @useResult
$Res call({
 String? cleanName, String? alsoKnownAs
});




}
/// @nodoc
class __$StationAliasesCopyWithImpl<$Res>
    implements _$StationAliasesCopyWith<$Res> {
  __$StationAliasesCopyWithImpl(this._self, this._then);

  final _StationAliases _self;
  final $Res Function(_StationAliases) _then;

/// Create a copy of StationAliases
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cleanName = freezed,Object? alsoKnownAs = freezed,}) {
  return _then(_StationAliases(
cleanName: freezed == cleanName ? _self.cleanName : cleanName // ignore: cast_nullable_to_non_nullable
as String?,alsoKnownAs: freezed == alsoKnownAs ? _self.alsoKnownAs : alsoKnownAs // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
