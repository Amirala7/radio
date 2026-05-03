// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeState {

 HomeTab get tab; bool get isSearchOpen; String get searchQuery; int? get activeGenreId; String? get activeGenreName;
/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeStateCopyWith<HomeState> get copyWith => _$HomeStateCopyWithImpl<HomeState>(this as HomeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeState&&(identical(other.tab, tab) || other.tab == tab)&&(identical(other.isSearchOpen, isSearchOpen) || other.isSearchOpen == isSearchOpen)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.activeGenreId, activeGenreId) || other.activeGenreId == activeGenreId)&&(identical(other.activeGenreName, activeGenreName) || other.activeGenreName == activeGenreName));
}


@override
int get hashCode => Object.hash(runtimeType,tab,isSearchOpen,searchQuery,activeGenreId,activeGenreName);

@override
String toString() {
  return 'HomeState(tab: $tab, isSearchOpen: $isSearchOpen, searchQuery: $searchQuery, activeGenreId: $activeGenreId, activeGenreName: $activeGenreName)';
}


}

/// @nodoc
abstract mixin class $HomeStateCopyWith<$Res>  {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) _then) = _$HomeStateCopyWithImpl;
@useResult
$Res call({
 HomeTab tab, bool isSearchOpen, String searchQuery, int? activeGenreId, String? activeGenreName
});




}
/// @nodoc
class _$HomeStateCopyWithImpl<$Res>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._self, this._then);

  final HomeState _self;
  final $Res Function(HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tab = null,Object? isSearchOpen = null,Object? searchQuery = null,Object? activeGenreId = freezed,Object? activeGenreName = freezed,}) {
  return _then(_self.copyWith(
tab: null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as HomeTab,isSearchOpen: null == isSearchOpen ? _self.isSearchOpen : isSearchOpen // ignore: cast_nullable_to_non_nullable
as bool,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,activeGenreId: freezed == activeGenreId ? _self.activeGenreId : activeGenreId // ignore: cast_nullable_to_non_nullable
as int?,activeGenreName: freezed == activeGenreName ? _self.activeGenreName : activeGenreName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeState value)  $default,){
final _that = this;
switch (_that) {
case _HomeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeState value)?  $default,){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( HomeTab tab,  bool isSearchOpen,  String searchQuery,  int? activeGenreId,  String? activeGenreName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.tab,_that.isSearchOpen,_that.searchQuery,_that.activeGenreId,_that.activeGenreName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( HomeTab tab,  bool isSearchOpen,  String searchQuery,  int? activeGenreId,  String? activeGenreName)  $default,) {final _that = this;
switch (_that) {
case _HomeState():
return $default(_that.tab,_that.isSearchOpen,_that.searchQuery,_that.activeGenreId,_that.activeGenreName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( HomeTab tab,  bool isSearchOpen,  String searchQuery,  int? activeGenreId,  String? activeGenreName)?  $default,) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.tab,_that.isSearchOpen,_that.searchQuery,_that.activeGenreId,_that.activeGenreName);case _:
  return null;

}
}

}

/// @nodoc


class _HomeState implements HomeState {
  const _HomeState({this.tab = HomeTab.popular, this.isSearchOpen = false, this.searchQuery = '', this.activeGenreId, this.activeGenreName});
  

@override@JsonKey() final  HomeTab tab;
@override@JsonKey() final  bool isSearchOpen;
@override@JsonKey() final  String searchQuery;
@override final  int? activeGenreId;
@override final  String? activeGenreName;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeStateCopyWith<_HomeState> get copyWith => __$HomeStateCopyWithImpl<_HomeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeState&&(identical(other.tab, tab) || other.tab == tab)&&(identical(other.isSearchOpen, isSearchOpen) || other.isSearchOpen == isSearchOpen)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.activeGenreId, activeGenreId) || other.activeGenreId == activeGenreId)&&(identical(other.activeGenreName, activeGenreName) || other.activeGenreName == activeGenreName));
}


@override
int get hashCode => Object.hash(runtimeType,tab,isSearchOpen,searchQuery,activeGenreId,activeGenreName);

@override
String toString() {
  return 'HomeState(tab: $tab, isSearchOpen: $isSearchOpen, searchQuery: $searchQuery, activeGenreId: $activeGenreId, activeGenreName: $activeGenreName)';
}


}

/// @nodoc
abstract mixin class _$HomeStateCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory _$HomeStateCopyWith(_HomeState value, $Res Function(_HomeState) _then) = __$HomeStateCopyWithImpl;
@override @useResult
$Res call({
 HomeTab tab, bool isSearchOpen, String searchQuery, int? activeGenreId, String? activeGenreName
});




}
/// @nodoc
class __$HomeStateCopyWithImpl<$Res>
    implements _$HomeStateCopyWith<$Res> {
  __$HomeStateCopyWithImpl(this._self, this._then);

  final _HomeState _self;
  final $Res Function(_HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tab = null,Object? isSearchOpen = null,Object? searchQuery = null,Object? activeGenreId = freezed,Object? activeGenreName = freezed,}) {
  return _then(_HomeState(
tab: null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as HomeTab,isSearchOpen: null == isSearchOpen ? _self.isSearchOpen : isSearchOpen // ignore: cast_nullable_to_non_nullable
as bool,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,activeGenreId: freezed == activeGenreId ? _self.activeGenreId : activeGenreId // ignore: cast_nullable_to_non_nullable
as int?,activeGenreName: freezed == activeGenreName ? _self.activeGenreName : activeGenreName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
