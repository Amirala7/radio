// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'station_dial.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StationDial {

 String? get band; String? get dial; String? get dialStripped;
/// Create a copy of StationDial
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StationDialCopyWith<StationDial> get copyWith => _$StationDialCopyWithImpl<StationDial>(this as StationDial, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StationDial&&(identical(other.band, band) || other.band == band)&&(identical(other.dial, dial) || other.dial == dial)&&(identical(other.dialStripped, dialStripped) || other.dialStripped == dialStripped));
}


@override
int get hashCode => Object.hash(runtimeType,band,dial,dialStripped);

@override
String toString() {
  return 'StationDial(band: $band, dial: $dial, dialStripped: $dialStripped)';
}


}

/// @nodoc
abstract mixin class $StationDialCopyWith<$Res>  {
  factory $StationDialCopyWith(StationDial value, $Res Function(StationDial) _then) = _$StationDialCopyWithImpl;
@useResult
$Res call({
 String? band, String? dial, String? dialStripped
});




}
/// @nodoc
class _$StationDialCopyWithImpl<$Res>
    implements $StationDialCopyWith<$Res> {
  _$StationDialCopyWithImpl(this._self, this._then);

  final StationDial _self;
  final $Res Function(StationDial) _then;

/// Create a copy of StationDial
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


/// Adds pattern-matching-related methods to [StationDial].
extension StationDialPatterns on StationDial {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StationDial value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StationDial() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StationDial value)  $default,){
final _that = this;
switch (_that) {
case _StationDial():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StationDial value)?  $default,){
final _that = this;
switch (_that) {
case _StationDial() when $default != null:
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
case _StationDial() when $default != null:
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
case _StationDial():
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
case _StationDial() when $default != null:
return $default(_that.band,_that.dial,_that.dialStripped);case _:
  return null;

}
}

}

/// @nodoc


class _StationDial implements StationDial {
  const _StationDial({this.band, this.dial, this.dialStripped});
  

@override final  String? band;
@override final  String? dial;
@override final  String? dialStripped;

/// Create a copy of StationDial
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StationDialCopyWith<_StationDial> get copyWith => __$StationDialCopyWithImpl<_StationDial>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StationDial&&(identical(other.band, band) || other.band == band)&&(identical(other.dial, dial) || other.dial == dial)&&(identical(other.dialStripped, dialStripped) || other.dialStripped == dialStripped));
}


@override
int get hashCode => Object.hash(runtimeType,band,dial,dialStripped);

@override
String toString() {
  return 'StationDial(band: $band, dial: $dial, dialStripped: $dialStripped)';
}


}

/// @nodoc
abstract mixin class _$StationDialCopyWith<$Res> implements $StationDialCopyWith<$Res> {
  factory _$StationDialCopyWith(_StationDial value, $Res Function(_StationDial) _then) = __$StationDialCopyWithImpl;
@override @useResult
$Res call({
 String? band, String? dial, String? dialStripped
});




}
/// @nodoc
class __$StationDialCopyWithImpl<$Res>
    implements _$StationDialCopyWith<$Res> {
  __$StationDialCopyWithImpl(this._self, this._then);

  final _StationDial _self;
  final $Res Function(_StationDial) _then;

/// Create a copy of StationDial
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? band = freezed,Object? dial = freezed,Object? dialStripped = freezed,}) {
  return _then(_StationDial(
band: freezed == band ? _self.band : band // ignore: cast_nullable_to_non_nullable
as String?,dial: freezed == dial ? _self.dial : dial // ignore: cast_nullable_to_non_nullable
as String?,dialStripped: freezed == dialStripped ? _self.dialStripped : dialStripped // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
