// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'page_meta_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PageMetaDto {

 int get page; int get limit; int? get total; int? get totalPages;
/// Create a copy of PageMetaDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PageMetaDtoCopyWith<PageMetaDto> get copyWith => _$PageMetaDtoCopyWithImpl<PageMetaDto>(this as PageMetaDto, _$identity);

  /// Serializes this PageMetaDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PageMetaDto&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.total, total) || other.total == total)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,limit,total,totalPages);

@override
String toString() {
  return 'PageMetaDto(page: $page, limit: $limit, total: $total, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class $PageMetaDtoCopyWith<$Res>  {
  factory $PageMetaDtoCopyWith(PageMetaDto value, $Res Function(PageMetaDto) _then) = _$PageMetaDtoCopyWithImpl;
@useResult
$Res call({
 int page, int limit, int? total, int? totalPages
});




}
/// @nodoc
class _$PageMetaDtoCopyWithImpl<$Res>
    implements $PageMetaDtoCopyWith<$Res> {
  _$PageMetaDtoCopyWithImpl(this._self, this._then);

  final PageMetaDto _self;
  final $Res Function(PageMetaDto) _then;

/// Create a copy of PageMetaDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,Object? limit = null,Object? total = freezed,Object? totalPages = freezed,}) {
  return _then(_self.copyWith(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,totalPages: freezed == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [PageMetaDto].
extension PageMetaDtoPatterns on PageMetaDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PageMetaDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PageMetaDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PageMetaDto value)  $default,){
final _that = this;
switch (_that) {
case _PageMetaDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PageMetaDto value)?  $default,){
final _that = this;
switch (_that) {
case _PageMetaDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int page,  int limit,  int? total,  int? totalPages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PageMetaDto() when $default != null:
return $default(_that.page,_that.limit,_that.total,_that.totalPages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int page,  int limit,  int? total,  int? totalPages)  $default,) {final _that = this;
switch (_that) {
case _PageMetaDto():
return $default(_that.page,_that.limit,_that.total,_that.totalPages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int page,  int limit,  int? total,  int? totalPages)?  $default,) {final _that = this;
switch (_that) {
case _PageMetaDto() when $default != null:
return $default(_that.page,_that.limit,_that.total,_that.totalPages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PageMetaDto implements PageMetaDto {
  const _PageMetaDto({required this.page, required this.limit, this.total, this.totalPages});
  factory _PageMetaDto.fromJson(Map<String, dynamic> json) => _$PageMetaDtoFromJson(json);

@override final  int page;
@override final  int limit;
@override final  int? total;
@override final  int? totalPages;

/// Create a copy of PageMetaDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PageMetaDtoCopyWith<_PageMetaDto> get copyWith => __$PageMetaDtoCopyWithImpl<_PageMetaDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PageMetaDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PageMetaDto&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.total, total) || other.total == total)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,limit,total,totalPages);

@override
String toString() {
  return 'PageMetaDto(page: $page, limit: $limit, total: $total, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class _$PageMetaDtoCopyWith<$Res> implements $PageMetaDtoCopyWith<$Res> {
  factory _$PageMetaDtoCopyWith(_PageMetaDto value, $Res Function(_PageMetaDto) _then) = __$PageMetaDtoCopyWithImpl;
@override @useResult
$Res call({
 int page, int limit, int? total, int? totalPages
});




}
/// @nodoc
class __$PageMetaDtoCopyWithImpl<$Res>
    implements _$PageMetaDtoCopyWith<$Res> {
  __$PageMetaDtoCopyWithImpl(this._self, this._then);

  final _PageMetaDto _self;
  final $Res Function(_PageMetaDto) _then;

/// Create a copy of PageMetaDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,Object? limit = null,Object? total = freezed,Object? totalPages = freezed,}) {
  return _then(_PageMetaDto(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,totalPages: freezed == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
