// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'radio_stream.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RadioStream {

 String get url; int? get id; int? get bitrate; String? get contentType; String? get codec; String? get protocol; bool? get isHttps; bool? get works;
/// Create a copy of RadioStream
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RadioStreamCopyWith<RadioStream> get copyWith => _$RadioStreamCopyWithImpl<RadioStream>(this as RadioStream, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RadioStream&&(identical(other.url, url) || other.url == url)&&(identical(other.id, id) || other.id == id)&&(identical(other.bitrate, bitrate) || other.bitrate == bitrate)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.codec, codec) || other.codec == codec)&&(identical(other.protocol, protocol) || other.protocol == protocol)&&(identical(other.isHttps, isHttps) || other.isHttps == isHttps)&&(identical(other.works, works) || other.works == works));
}


@override
int get hashCode => Object.hash(runtimeType,url,id,bitrate,contentType,codec,protocol,isHttps,works);

@override
String toString() {
  return 'RadioStream(url: $url, id: $id, bitrate: $bitrate, contentType: $contentType, codec: $codec, protocol: $protocol, isHttps: $isHttps, works: $works)';
}


}

/// @nodoc
abstract mixin class $RadioStreamCopyWith<$Res>  {
  factory $RadioStreamCopyWith(RadioStream value, $Res Function(RadioStream) _then) = _$RadioStreamCopyWithImpl;
@useResult
$Res call({
 String url, int? id, int? bitrate, String? contentType, String? codec, String? protocol, bool? isHttps, bool? works
});




}
/// @nodoc
class _$RadioStreamCopyWithImpl<$Res>
    implements $RadioStreamCopyWith<$Res> {
  _$RadioStreamCopyWithImpl(this._self, this._then);

  final RadioStream _self;
  final $Res Function(RadioStream) _then;

/// Create a copy of RadioStream
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? id = freezed,Object? bitrate = freezed,Object? contentType = freezed,Object? codec = freezed,Object? protocol = freezed,Object? isHttps = freezed,Object? works = freezed,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,bitrate: freezed == bitrate ? _self.bitrate : bitrate // ignore: cast_nullable_to_non_nullable
as int?,contentType: freezed == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String?,codec: freezed == codec ? _self.codec : codec // ignore: cast_nullable_to_non_nullable
as String?,protocol: freezed == protocol ? _self.protocol : protocol // ignore: cast_nullable_to_non_nullable
as String?,isHttps: freezed == isHttps ? _self.isHttps : isHttps // ignore: cast_nullable_to_non_nullable
as bool?,works: freezed == works ? _self.works : works // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [RadioStream].
extension RadioStreamPatterns on RadioStream {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RadioStream value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RadioStream() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RadioStream value)  $default,){
final _that = this;
switch (_that) {
case _RadioStream():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RadioStream value)?  $default,){
final _that = this;
switch (_that) {
case _RadioStream() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url,  int? id,  int? bitrate,  String? contentType,  String? codec,  String? protocol,  bool? isHttps,  bool? works)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RadioStream() when $default != null:
return $default(_that.url,_that.id,_that.bitrate,_that.contentType,_that.codec,_that.protocol,_that.isHttps,_that.works);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url,  int? id,  int? bitrate,  String? contentType,  String? codec,  String? protocol,  bool? isHttps,  bool? works)  $default,) {final _that = this;
switch (_that) {
case _RadioStream():
return $default(_that.url,_that.id,_that.bitrate,_that.contentType,_that.codec,_that.protocol,_that.isHttps,_that.works);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url,  int? id,  int? bitrate,  String? contentType,  String? codec,  String? protocol,  bool? isHttps,  bool? works)?  $default,) {final _that = this;
switch (_that) {
case _RadioStream() when $default != null:
return $default(_that.url,_that.id,_that.bitrate,_that.contentType,_that.codec,_that.protocol,_that.isHttps,_that.works);case _:
  return null;

}
}

}

/// @nodoc


class _RadioStream implements RadioStream {
  const _RadioStream({required this.url, this.id, this.bitrate, this.contentType, this.codec, this.protocol, this.isHttps, this.works});
  

@override final  String url;
@override final  int? id;
@override final  int? bitrate;
@override final  String? contentType;
@override final  String? codec;
@override final  String? protocol;
@override final  bool? isHttps;
@override final  bool? works;

/// Create a copy of RadioStream
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RadioStreamCopyWith<_RadioStream> get copyWith => __$RadioStreamCopyWithImpl<_RadioStream>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RadioStream&&(identical(other.url, url) || other.url == url)&&(identical(other.id, id) || other.id == id)&&(identical(other.bitrate, bitrate) || other.bitrate == bitrate)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.codec, codec) || other.codec == codec)&&(identical(other.protocol, protocol) || other.protocol == protocol)&&(identical(other.isHttps, isHttps) || other.isHttps == isHttps)&&(identical(other.works, works) || other.works == works));
}


@override
int get hashCode => Object.hash(runtimeType,url,id,bitrate,contentType,codec,protocol,isHttps,works);

@override
String toString() {
  return 'RadioStream(url: $url, id: $id, bitrate: $bitrate, contentType: $contentType, codec: $codec, protocol: $protocol, isHttps: $isHttps, works: $works)';
}


}

/// @nodoc
abstract mixin class _$RadioStreamCopyWith<$Res> implements $RadioStreamCopyWith<$Res> {
  factory _$RadioStreamCopyWith(_RadioStream value, $Res Function(_RadioStream) _then) = __$RadioStreamCopyWithImpl;
@override @useResult
$Res call({
 String url, int? id, int? bitrate, String? contentType, String? codec, String? protocol, bool? isHttps, bool? works
});




}
/// @nodoc
class __$RadioStreamCopyWithImpl<$Res>
    implements _$RadioStreamCopyWith<$Res> {
  __$RadioStreamCopyWithImpl(this._self, this._then);

  final _RadioStream _self;
  final $Res Function(_RadioStream) _then;

/// Create a copy of RadioStream
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? id = freezed,Object? bitrate = freezed,Object? contentType = freezed,Object? codec = freezed,Object? protocol = freezed,Object? isHttps = freezed,Object? works = freezed,}) {
  return _then(_RadioStream(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,bitrate: freezed == bitrate ? _self.bitrate : bitrate // ignore: cast_nullable_to_non_nullable
as int?,contentType: freezed == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String?,codec: freezed == codec ? _self.codec : codec // ignore: cast_nullable_to_non_nullable
as String?,protocol: freezed == protocol ? _self.protocol : protocol // ignore: cast_nullable_to_non_nullable
as String?,isHttps: freezed == isHttps ? _self.isHttps : isHttps // ignore: cast_nullable_to_non_nullable
as bool?,works: freezed == works ? _self.works : works // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
