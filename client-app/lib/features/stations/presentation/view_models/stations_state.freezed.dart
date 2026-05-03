// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stations_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StationsState {

 StationsMode get mode; List<Station> get items; int get page; int get limit; bool get isLoading; bool get isLoadingMore; bool get hasMore; String? get query; String? get country; int? get genreId; String? get genreSlug; AppFailure? get error;
/// Create a copy of StationsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StationsStateCopyWith<StationsState> get copyWith => _$StationsStateCopyWithImpl<StationsState>(this as StationsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StationsState&&(identical(other.mode, mode) || other.mode == mode)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.query, query) || other.query == query)&&(identical(other.country, country) || other.country == country)&&(identical(other.genreId, genreId) || other.genreId == genreId)&&(identical(other.genreSlug, genreSlug) || other.genreSlug == genreSlug)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,mode,const DeepCollectionEquality().hash(items),page,limit,isLoading,isLoadingMore,hasMore,query,country,genreId,genreSlug,error);

@override
String toString() {
  return 'StationsState(mode: $mode, items: $items, page: $page, limit: $limit, isLoading: $isLoading, isLoadingMore: $isLoadingMore, hasMore: $hasMore, query: $query, country: $country, genreId: $genreId, genreSlug: $genreSlug, error: $error)';
}


}

/// @nodoc
abstract mixin class $StationsStateCopyWith<$Res>  {
  factory $StationsStateCopyWith(StationsState value, $Res Function(StationsState) _then) = _$StationsStateCopyWithImpl;
@useResult
$Res call({
 StationsMode mode, List<Station> items, int page, int limit, bool isLoading, bool isLoadingMore, bool hasMore, String? query, String? country, int? genreId, String? genreSlug, AppFailure? error
});




}
/// @nodoc
class _$StationsStateCopyWithImpl<$Res>
    implements $StationsStateCopyWith<$Res> {
  _$StationsStateCopyWithImpl(this._self, this._then);

  final StationsState _self;
  final $Res Function(StationsState) _then;

/// Create a copy of StationsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? items = null,Object? page = null,Object? limit = null,Object? isLoading = null,Object? isLoadingMore = null,Object? hasMore = null,Object? query = freezed,Object? country = freezed,Object? genreId = freezed,Object? genreSlug = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as StationsMode,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Station>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,query: freezed == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,genreId: freezed == genreId ? _self.genreId : genreId // ignore: cast_nullable_to_non_nullable
as int?,genreSlug: freezed == genreSlug ? _self.genreSlug : genreSlug // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}

}


/// Adds pattern-matching-related methods to [StationsState].
extension StationsStatePatterns on StationsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StationsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StationsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StationsState value)  $default,){
final _that = this;
switch (_that) {
case _StationsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StationsState value)?  $default,){
final _that = this;
switch (_that) {
case _StationsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StationsMode mode,  List<Station> items,  int page,  int limit,  bool isLoading,  bool isLoadingMore,  bool hasMore,  String? query,  String? country,  int? genreId,  String? genreSlug,  AppFailure? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StationsState() when $default != null:
return $default(_that.mode,_that.items,_that.page,_that.limit,_that.isLoading,_that.isLoadingMore,_that.hasMore,_that.query,_that.country,_that.genreId,_that.genreSlug,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StationsMode mode,  List<Station> items,  int page,  int limit,  bool isLoading,  bool isLoadingMore,  bool hasMore,  String? query,  String? country,  int? genreId,  String? genreSlug,  AppFailure? error)  $default,) {final _that = this;
switch (_that) {
case _StationsState():
return $default(_that.mode,_that.items,_that.page,_that.limit,_that.isLoading,_that.isLoadingMore,_that.hasMore,_that.query,_that.country,_that.genreId,_that.genreSlug,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StationsMode mode,  List<Station> items,  int page,  int limit,  bool isLoading,  bool isLoadingMore,  bool hasMore,  String? query,  String? country,  int? genreId,  String? genreSlug,  AppFailure? error)?  $default,) {final _that = this;
switch (_that) {
case _StationsState() when $default != null:
return $default(_that.mode,_that.items,_that.page,_that.limit,_that.isLoading,_that.isLoadingMore,_that.hasMore,_that.query,_that.country,_that.genreId,_that.genreSlug,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _StationsState implements StationsState {
  const _StationsState({this.mode = StationsMode.list, final  List<Station> items = const <Station>[], this.page = 1, this.limit = 20, this.isLoading = false, this.isLoadingMore = false, this.hasMore = true, this.query, this.country, this.genreId, this.genreSlug, this.error}): _items = items;
  

@override@JsonKey() final  StationsMode mode;
 final  List<Station> _items;
@override@JsonKey() List<Station> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  int page;
@override@JsonKey() final  int limit;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  bool hasMore;
@override final  String? query;
@override final  String? country;
@override final  int? genreId;
@override final  String? genreSlug;
@override final  AppFailure? error;

/// Create a copy of StationsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StationsStateCopyWith<_StationsState> get copyWith => __$StationsStateCopyWithImpl<_StationsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StationsState&&(identical(other.mode, mode) || other.mode == mode)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.query, query) || other.query == query)&&(identical(other.country, country) || other.country == country)&&(identical(other.genreId, genreId) || other.genreId == genreId)&&(identical(other.genreSlug, genreSlug) || other.genreSlug == genreSlug)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,mode,const DeepCollectionEquality().hash(_items),page,limit,isLoading,isLoadingMore,hasMore,query,country,genreId,genreSlug,error);

@override
String toString() {
  return 'StationsState(mode: $mode, items: $items, page: $page, limit: $limit, isLoading: $isLoading, isLoadingMore: $isLoadingMore, hasMore: $hasMore, query: $query, country: $country, genreId: $genreId, genreSlug: $genreSlug, error: $error)';
}


}

/// @nodoc
abstract mixin class _$StationsStateCopyWith<$Res> implements $StationsStateCopyWith<$Res> {
  factory _$StationsStateCopyWith(_StationsState value, $Res Function(_StationsState) _then) = __$StationsStateCopyWithImpl;
@override @useResult
$Res call({
 StationsMode mode, List<Station> items, int page, int limit, bool isLoading, bool isLoadingMore, bool hasMore, String? query, String? country, int? genreId, String? genreSlug, AppFailure? error
});




}
/// @nodoc
class __$StationsStateCopyWithImpl<$Res>
    implements _$StationsStateCopyWith<$Res> {
  __$StationsStateCopyWithImpl(this._self, this._then);

  final _StationsState _self;
  final $Res Function(_StationsState) _then;

/// Create a copy of StationsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? items = null,Object? page = null,Object? limit = null,Object? isLoading = null,Object? isLoadingMore = null,Object? hasMore = null,Object? query = freezed,Object? country = freezed,Object? genreId = freezed,Object? genreSlug = freezed,Object? error = freezed,}) {
  return _then(_StationsState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as StationsMode,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Station>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,query: freezed == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,genreId: freezed == genreId ? _self.genreId : genreId // ignore: cast_nullable_to_non_nullable
as int?,genreSlug: freezed == genreSlug ? _self.genreSlug : genreSlug // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}


}

// dart format on
