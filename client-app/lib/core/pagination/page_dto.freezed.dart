// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'page_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PageDto<T> {

 List<T> get data; PageMetaDto get meta; List<String>? get keywords;
/// Create a copy of PageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PageDtoCopyWith<T, PageDto<T>> get copyWith => _$PageDtoCopyWithImpl<T, PageDto<T>>(this as PageDto<T>, _$identity);

  /// Serializes this PageDto to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT);


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PageDto<T>&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.meta, meta) || other.meta == meta)&&const DeepCollectionEquality().equals(other.keywords, keywords));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),meta,const DeepCollectionEquality().hash(keywords));

@override
String toString() {
  return 'PageDto<$T>(data: $data, meta: $meta, keywords: $keywords)';
}


}

/// @nodoc
abstract mixin class $PageDtoCopyWith<T,$Res>  {
  factory $PageDtoCopyWith(PageDto<T> value, $Res Function(PageDto<T>) _then) = _$PageDtoCopyWithImpl;
@useResult
$Res call({
 List<T> data, PageMetaDto meta, List<String>? keywords
});


$PageMetaDtoCopyWith<$Res> get meta;

}
/// @nodoc
class _$PageDtoCopyWithImpl<T,$Res>
    implements $PageDtoCopyWith<T, $Res> {
  _$PageDtoCopyWithImpl(this._self, this._then);

  final PageDto<T> _self;
  final $Res Function(PageDto<T>) _then;

/// Create a copy of PageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,Object? meta = null,Object? keywords = freezed,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<T>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as PageMetaDto,keywords: freezed == keywords ? _self.keywords : keywords // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}
/// Create a copy of PageDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PageMetaDtoCopyWith<$Res> get meta {
  
  return $PageMetaDtoCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [PageDto].
extension PageDtoPatterns<T> on PageDto<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PageDto<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PageDto<T> value)  $default,){
final _that = this;
switch (_that) {
case _PageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PageDto<T> value)?  $default,){
final _that = this;
switch (_that) {
case _PageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<T> data,  PageMetaDto meta,  List<String>? keywords)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PageDto() when $default != null:
return $default(_that.data,_that.meta,_that.keywords);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<T> data,  PageMetaDto meta,  List<String>? keywords)  $default,) {final _that = this;
switch (_that) {
case _PageDto():
return $default(_that.data,_that.meta,_that.keywords);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<T> data,  PageMetaDto meta,  List<String>? keywords)?  $default,) {final _that = this;
switch (_that) {
case _PageDto() when $default != null:
return $default(_that.data,_that.meta,_that.keywords);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)

class _PageDto<T> implements PageDto<T> {
  const _PageDto({required final  List<T> data, required this.meta, final  List<String>? keywords}): _data = data,_keywords = keywords;
  factory _PageDto.fromJson(Map<String, dynamic> json,T Function(Object?) fromJsonT) => _$PageDtoFromJson(json,fromJsonT);

 final  List<T> _data;
@override List<T> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override final  PageMetaDto meta;
 final  List<String>? _keywords;
@override List<String>? get keywords {
  final value = _keywords;
  if (value == null) return null;
  if (_keywords is EqualUnmodifiableListView) return _keywords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of PageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PageDtoCopyWith<T, _PageDto<T>> get copyWith => __$PageDtoCopyWithImpl<T, _PageDto<T>>(this, _$identity);

@override
Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
  return _$PageDtoToJson<T>(this, toJsonT);
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PageDto<T>&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.meta, meta) || other.meta == meta)&&const DeepCollectionEquality().equals(other._keywords, _keywords));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data),meta,const DeepCollectionEquality().hash(_keywords));

@override
String toString() {
  return 'PageDto<$T>(data: $data, meta: $meta, keywords: $keywords)';
}


}

/// @nodoc
abstract mixin class _$PageDtoCopyWith<T,$Res> implements $PageDtoCopyWith<T, $Res> {
  factory _$PageDtoCopyWith(_PageDto<T> value, $Res Function(_PageDto<T>) _then) = __$PageDtoCopyWithImpl;
@override @useResult
$Res call({
 List<T> data, PageMetaDto meta, List<String>? keywords
});


@override $PageMetaDtoCopyWith<$Res> get meta;

}
/// @nodoc
class __$PageDtoCopyWithImpl<T,$Res>
    implements _$PageDtoCopyWith<T, $Res> {
  __$PageDtoCopyWithImpl(this._self, this._then);

  final _PageDto<T> _self;
  final $Res Function(_PageDto<T>) _then;

/// Create a copy of PageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,Object? meta = null,Object? keywords = freezed,}) {
  return _then(_PageDto<T>(
data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<T>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as PageMetaDto,keywords: freezed == keywords ? _self._keywords : keywords // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

/// Create a copy of PageDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PageMetaDtoCopyWith<$Res> get meta {
  
  return $PageMetaDtoCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

// dart format on
