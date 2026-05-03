// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'station.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Station {

 int get id; String get name; List<RadioStream> get streams; String? get slug; bool? get isActive; String? get logo; StationDial? get dial; StationAliases? get aliases; StationLocation? get location; StationGenre? get genre; StationPopularity? get popularity; List<StationLanguage>? get languages;
/// Create a copy of Station
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StationCopyWith<Station> get copyWith => _$StationCopyWithImpl<Station>(this as Station, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Station&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.streams, streams)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.dial, dial) || other.dial == dial)&&(identical(other.aliases, aliases) || other.aliases == aliases)&&(identical(other.location, location) || other.location == location)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&const DeepCollectionEquality().equals(other.languages, languages));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(streams),slug,isActive,logo,dial,aliases,location,genre,popularity,const DeepCollectionEquality().hash(languages));

@override
String toString() {
  return 'Station(id: $id, name: $name, streams: $streams, slug: $slug, isActive: $isActive, logo: $logo, dial: $dial, aliases: $aliases, location: $location, genre: $genre, popularity: $popularity, languages: $languages)';
}


}

/// @nodoc
abstract mixin class $StationCopyWith<$Res>  {
  factory $StationCopyWith(Station value, $Res Function(Station) _then) = _$StationCopyWithImpl;
@useResult
$Res call({
 int id, String name, List<RadioStream> streams, String? slug, bool? isActive, String? logo, StationDial? dial, StationAliases? aliases, StationLocation? location, StationGenre? genre, StationPopularity? popularity, List<StationLanguage>? languages
});


$StationDialCopyWith<$Res>? get dial;$StationAliasesCopyWith<$Res>? get aliases;$StationLocationCopyWith<$Res>? get location;$StationGenreCopyWith<$Res>? get genre;$StationPopularityCopyWith<$Res>? get popularity;

}
/// @nodoc
class _$StationCopyWithImpl<$Res>
    implements $StationCopyWith<$Res> {
  _$StationCopyWithImpl(this._self, this._then);

  final Station _self;
  final $Res Function(Station) _then;

/// Create a copy of Station
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? streams = null,Object? slug = freezed,Object? isActive = freezed,Object? logo = freezed,Object? dial = freezed,Object? aliases = freezed,Object? location = freezed,Object? genre = freezed,Object? popularity = freezed,Object? languages = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,streams: null == streams ? _self.streams : streams // ignore: cast_nullable_to_non_nullable
as List<RadioStream>,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,dial: freezed == dial ? _self.dial : dial // ignore: cast_nullable_to_non_nullable
as StationDial?,aliases: freezed == aliases ? _self.aliases : aliases // ignore: cast_nullable_to_non_nullable
as StationAliases?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as StationLocation?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as StationGenre?,popularity: freezed == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as StationPopularity?,languages: freezed == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as List<StationLanguage>?,
  ));
}
/// Create a copy of Station
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationDialCopyWith<$Res>? get dial {
    if (_self.dial == null) {
    return null;
  }

  return $StationDialCopyWith<$Res>(_self.dial!, (value) {
    return _then(_self.copyWith(dial: value));
  });
}/// Create a copy of Station
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationAliasesCopyWith<$Res>? get aliases {
    if (_self.aliases == null) {
    return null;
  }

  return $StationAliasesCopyWith<$Res>(_self.aliases!, (value) {
    return _then(_self.copyWith(aliases: value));
  });
}/// Create a copy of Station
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationLocationCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $StationLocationCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}/// Create a copy of Station
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationGenreCopyWith<$Res>? get genre {
    if (_self.genre == null) {
    return null;
  }

  return $StationGenreCopyWith<$Res>(_self.genre!, (value) {
    return _then(_self.copyWith(genre: value));
  });
}/// Create a copy of Station
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationPopularityCopyWith<$Res>? get popularity {
    if (_self.popularity == null) {
    return null;
  }

  return $StationPopularityCopyWith<$Res>(_self.popularity!, (value) {
    return _then(_self.copyWith(popularity: value));
  });
}
}


/// Adds pattern-matching-related methods to [Station].
extension StationPatterns on Station {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Station value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Station() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Station value)  $default,){
final _that = this;
switch (_that) {
case _Station():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Station value)?  $default,){
final _that = this;
switch (_that) {
case _Station() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  List<RadioStream> streams,  String? slug,  bool? isActive,  String? logo,  StationDial? dial,  StationAliases? aliases,  StationLocation? location,  StationGenre? genre,  StationPopularity? popularity,  List<StationLanguage>? languages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Station() when $default != null:
return $default(_that.id,_that.name,_that.streams,_that.slug,_that.isActive,_that.logo,_that.dial,_that.aliases,_that.location,_that.genre,_that.popularity,_that.languages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  List<RadioStream> streams,  String? slug,  bool? isActive,  String? logo,  StationDial? dial,  StationAliases? aliases,  StationLocation? location,  StationGenre? genre,  StationPopularity? popularity,  List<StationLanguage>? languages)  $default,) {final _that = this;
switch (_that) {
case _Station():
return $default(_that.id,_that.name,_that.streams,_that.slug,_that.isActive,_that.logo,_that.dial,_that.aliases,_that.location,_that.genre,_that.popularity,_that.languages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  List<RadioStream> streams,  String? slug,  bool? isActive,  String? logo,  StationDial? dial,  StationAliases? aliases,  StationLocation? location,  StationGenre? genre,  StationPopularity? popularity,  List<StationLanguage>? languages)?  $default,) {final _that = this;
switch (_that) {
case _Station() when $default != null:
return $default(_that.id,_that.name,_that.streams,_that.slug,_that.isActive,_that.logo,_that.dial,_that.aliases,_that.location,_that.genre,_that.popularity,_that.languages);case _:
  return null;

}
}

}

/// @nodoc


class _Station implements Station {
  const _Station({required this.id, required this.name, required final  List<RadioStream> streams, this.slug, this.isActive, this.logo, this.dial, this.aliases, this.location, this.genre, this.popularity, final  List<StationLanguage>? languages}): _streams = streams,_languages = languages;
  

@override final  int id;
@override final  String name;
 final  List<RadioStream> _streams;
@override List<RadioStream> get streams {
  if (_streams is EqualUnmodifiableListView) return _streams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_streams);
}

@override final  String? slug;
@override final  bool? isActive;
@override final  String? logo;
@override final  StationDial? dial;
@override final  StationAliases? aliases;
@override final  StationLocation? location;
@override final  StationGenre? genre;
@override final  StationPopularity? popularity;
 final  List<StationLanguage>? _languages;
@override List<StationLanguage>? get languages {
  final value = _languages;
  if (value == null) return null;
  if (_languages is EqualUnmodifiableListView) return _languages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of Station
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StationCopyWith<_Station> get copyWith => __$StationCopyWithImpl<_Station>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Station&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._streams, _streams)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.dial, dial) || other.dial == dial)&&(identical(other.aliases, aliases) || other.aliases == aliases)&&(identical(other.location, location) || other.location == location)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&const DeepCollectionEquality().equals(other._languages, _languages));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_streams),slug,isActive,logo,dial,aliases,location,genre,popularity,const DeepCollectionEquality().hash(_languages));

@override
String toString() {
  return 'Station(id: $id, name: $name, streams: $streams, slug: $slug, isActive: $isActive, logo: $logo, dial: $dial, aliases: $aliases, location: $location, genre: $genre, popularity: $popularity, languages: $languages)';
}


}

/// @nodoc
abstract mixin class _$StationCopyWith<$Res> implements $StationCopyWith<$Res> {
  factory _$StationCopyWith(_Station value, $Res Function(_Station) _then) = __$StationCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, List<RadioStream> streams, String? slug, bool? isActive, String? logo, StationDial? dial, StationAliases? aliases, StationLocation? location, StationGenre? genre, StationPopularity? popularity, List<StationLanguage>? languages
});


@override $StationDialCopyWith<$Res>? get dial;@override $StationAliasesCopyWith<$Res>? get aliases;@override $StationLocationCopyWith<$Res>? get location;@override $StationGenreCopyWith<$Res>? get genre;@override $StationPopularityCopyWith<$Res>? get popularity;

}
/// @nodoc
class __$StationCopyWithImpl<$Res>
    implements _$StationCopyWith<$Res> {
  __$StationCopyWithImpl(this._self, this._then);

  final _Station _self;
  final $Res Function(_Station) _then;

/// Create a copy of Station
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? streams = null,Object? slug = freezed,Object? isActive = freezed,Object? logo = freezed,Object? dial = freezed,Object? aliases = freezed,Object? location = freezed,Object? genre = freezed,Object? popularity = freezed,Object? languages = freezed,}) {
  return _then(_Station(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,streams: null == streams ? _self._streams : streams // ignore: cast_nullable_to_non_nullable
as List<RadioStream>,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,dial: freezed == dial ? _self.dial : dial // ignore: cast_nullable_to_non_nullable
as StationDial?,aliases: freezed == aliases ? _self.aliases : aliases // ignore: cast_nullable_to_non_nullable
as StationAliases?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as StationLocation?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as StationGenre?,popularity: freezed == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as StationPopularity?,languages: freezed == languages ? _self._languages : languages // ignore: cast_nullable_to_non_nullable
as List<StationLanguage>?,
  ));
}

/// Create a copy of Station
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationDialCopyWith<$Res>? get dial {
    if (_self.dial == null) {
    return null;
  }

  return $StationDialCopyWith<$Res>(_self.dial!, (value) {
    return _then(_self.copyWith(dial: value));
  });
}/// Create a copy of Station
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationAliasesCopyWith<$Res>? get aliases {
    if (_self.aliases == null) {
    return null;
  }

  return $StationAliasesCopyWith<$Res>(_self.aliases!, (value) {
    return _then(_self.copyWith(aliases: value));
  });
}/// Create a copy of Station
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationLocationCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $StationLocationCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}/// Create a copy of Station
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationGenreCopyWith<$Res>? get genre {
    if (_self.genre == null) {
    return null;
  }

  return $StationGenreCopyWith<$Res>(_self.genre!, (value) {
    return _then(_self.copyWith(genre: value));
  });
}/// Create a copy of Station
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationPopularityCopyWith<$Res>? get popularity {
    if (_self.popularity == null) {
    return null;
  }

  return $StationPopularityCopyWith<$Res>(_self.popularity!, (value) {
    return _then(_self.copyWith(popularity: value));
  });
}
}

// dart format on
