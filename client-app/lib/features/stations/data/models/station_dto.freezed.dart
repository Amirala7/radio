// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'station_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StationDto {

 int get id; String get name; List<StreamDto> get streams; String? get slug; bool? get isActive; String? get logo; StationDialDto? get dial; StationAliasesDto? get aliases; StationLocationDto? get location; StationGenreDto? get genre; StationPopularityDto? get popularity; List<StationLanguageDto>? get languages;
/// Create a copy of StationDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StationDtoCopyWith<StationDto> get copyWith => _$StationDtoCopyWithImpl<StationDto>(this as StationDto, _$identity);

  /// Serializes this StationDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StationDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.streams, streams)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.dial, dial) || other.dial == dial)&&(identical(other.aliases, aliases) || other.aliases == aliases)&&(identical(other.location, location) || other.location == location)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&const DeepCollectionEquality().equals(other.languages, languages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(streams),slug,isActive,logo,dial,aliases,location,genre,popularity,const DeepCollectionEquality().hash(languages));

@override
String toString() {
  return 'StationDto(id: $id, name: $name, streams: $streams, slug: $slug, isActive: $isActive, logo: $logo, dial: $dial, aliases: $aliases, location: $location, genre: $genre, popularity: $popularity, languages: $languages)';
}


}

/// @nodoc
abstract mixin class $StationDtoCopyWith<$Res>  {
  factory $StationDtoCopyWith(StationDto value, $Res Function(StationDto) _then) = _$StationDtoCopyWithImpl;
@useResult
$Res call({
 int id, String name, List<StreamDto> streams, String? slug, bool? isActive, String? logo, StationDialDto? dial, StationAliasesDto? aliases, StationLocationDto? location, StationGenreDto? genre, StationPopularityDto? popularity, List<StationLanguageDto>? languages
});


$StationDialDtoCopyWith<$Res>? get dial;$StationAliasesDtoCopyWith<$Res>? get aliases;$StationLocationDtoCopyWith<$Res>? get location;$StationGenreDtoCopyWith<$Res>? get genre;$StationPopularityDtoCopyWith<$Res>? get popularity;

}
/// @nodoc
class _$StationDtoCopyWithImpl<$Res>
    implements $StationDtoCopyWith<$Res> {
  _$StationDtoCopyWithImpl(this._self, this._then);

  final StationDto _self;
  final $Res Function(StationDto) _then;

/// Create a copy of StationDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? streams = null,Object? slug = freezed,Object? isActive = freezed,Object? logo = freezed,Object? dial = freezed,Object? aliases = freezed,Object? location = freezed,Object? genre = freezed,Object? popularity = freezed,Object? languages = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,streams: null == streams ? _self.streams : streams // ignore: cast_nullable_to_non_nullable
as List<StreamDto>,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,dial: freezed == dial ? _self.dial : dial // ignore: cast_nullable_to_non_nullable
as StationDialDto?,aliases: freezed == aliases ? _self.aliases : aliases // ignore: cast_nullable_to_non_nullable
as StationAliasesDto?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as StationLocationDto?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as StationGenreDto?,popularity: freezed == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as StationPopularityDto?,languages: freezed == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as List<StationLanguageDto>?,
  ));
}
/// Create a copy of StationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationDialDtoCopyWith<$Res>? get dial {
    if (_self.dial == null) {
    return null;
  }

  return $StationDialDtoCopyWith<$Res>(_self.dial!, (value) {
    return _then(_self.copyWith(dial: value));
  });
}/// Create a copy of StationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationAliasesDtoCopyWith<$Res>? get aliases {
    if (_self.aliases == null) {
    return null;
  }

  return $StationAliasesDtoCopyWith<$Res>(_self.aliases!, (value) {
    return _then(_self.copyWith(aliases: value));
  });
}/// Create a copy of StationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationLocationDtoCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $StationLocationDtoCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}/// Create a copy of StationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationGenreDtoCopyWith<$Res>? get genre {
    if (_self.genre == null) {
    return null;
  }

  return $StationGenreDtoCopyWith<$Res>(_self.genre!, (value) {
    return _then(_self.copyWith(genre: value));
  });
}/// Create a copy of StationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationPopularityDtoCopyWith<$Res>? get popularity {
    if (_self.popularity == null) {
    return null;
  }

  return $StationPopularityDtoCopyWith<$Res>(_self.popularity!, (value) {
    return _then(_self.copyWith(popularity: value));
  });
}
}


/// Adds pattern-matching-related methods to [StationDto].
extension StationDtoPatterns on StationDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StationDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StationDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StationDto value)  $default,){
final _that = this;
switch (_that) {
case _StationDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StationDto value)?  $default,){
final _that = this;
switch (_that) {
case _StationDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  List<StreamDto> streams,  String? slug,  bool? isActive,  String? logo,  StationDialDto? dial,  StationAliasesDto? aliases,  StationLocationDto? location,  StationGenreDto? genre,  StationPopularityDto? popularity,  List<StationLanguageDto>? languages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StationDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  List<StreamDto> streams,  String? slug,  bool? isActive,  String? logo,  StationDialDto? dial,  StationAliasesDto? aliases,  StationLocationDto? location,  StationGenreDto? genre,  StationPopularityDto? popularity,  List<StationLanguageDto>? languages)  $default,) {final _that = this;
switch (_that) {
case _StationDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  List<StreamDto> streams,  String? slug,  bool? isActive,  String? logo,  StationDialDto? dial,  StationAliasesDto? aliases,  StationLocationDto? location,  StationGenreDto? genre,  StationPopularityDto? popularity,  List<StationLanguageDto>? languages)?  $default,) {final _that = this;
switch (_that) {
case _StationDto() when $default != null:
return $default(_that.id,_that.name,_that.streams,_that.slug,_that.isActive,_that.logo,_that.dial,_that.aliases,_that.location,_that.genre,_that.popularity,_that.languages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StationDto implements StationDto {
  const _StationDto({required this.id, required this.name, required final  List<StreamDto> streams, this.slug, this.isActive, this.logo, this.dial, this.aliases, this.location, this.genre, this.popularity, final  List<StationLanguageDto>? languages}): _streams = streams,_languages = languages;
  factory _StationDto.fromJson(Map<String, dynamic> json) => _$StationDtoFromJson(json);

@override final  int id;
@override final  String name;
 final  List<StreamDto> _streams;
@override List<StreamDto> get streams {
  if (_streams is EqualUnmodifiableListView) return _streams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_streams);
}

@override final  String? slug;
@override final  bool? isActive;
@override final  String? logo;
@override final  StationDialDto? dial;
@override final  StationAliasesDto? aliases;
@override final  StationLocationDto? location;
@override final  StationGenreDto? genre;
@override final  StationPopularityDto? popularity;
 final  List<StationLanguageDto>? _languages;
@override List<StationLanguageDto>? get languages {
  final value = _languages;
  if (value == null) return null;
  if (_languages is EqualUnmodifiableListView) return _languages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of StationDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StationDtoCopyWith<_StationDto> get copyWith => __$StationDtoCopyWithImpl<_StationDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StationDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StationDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._streams, _streams)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.dial, dial) || other.dial == dial)&&(identical(other.aliases, aliases) || other.aliases == aliases)&&(identical(other.location, location) || other.location == location)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&const DeepCollectionEquality().equals(other._languages, _languages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_streams),slug,isActive,logo,dial,aliases,location,genre,popularity,const DeepCollectionEquality().hash(_languages));

@override
String toString() {
  return 'StationDto(id: $id, name: $name, streams: $streams, slug: $slug, isActive: $isActive, logo: $logo, dial: $dial, aliases: $aliases, location: $location, genre: $genre, popularity: $popularity, languages: $languages)';
}


}

/// @nodoc
abstract mixin class _$StationDtoCopyWith<$Res> implements $StationDtoCopyWith<$Res> {
  factory _$StationDtoCopyWith(_StationDto value, $Res Function(_StationDto) _then) = __$StationDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, List<StreamDto> streams, String? slug, bool? isActive, String? logo, StationDialDto? dial, StationAliasesDto? aliases, StationLocationDto? location, StationGenreDto? genre, StationPopularityDto? popularity, List<StationLanguageDto>? languages
});


@override $StationDialDtoCopyWith<$Res>? get dial;@override $StationAliasesDtoCopyWith<$Res>? get aliases;@override $StationLocationDtoCopyWith<$Res>? get location;@override $StationGenreDtoCopyWith<$Res>? get genre;@override $StationPopularityDtoCopyWith<$Res>? get popularity;

}
/// @nodoc
class __$StationDtoCopyWithImpl<$Res>
    implements _$StationDtoCopyWith<$Res> {
  __$StationDtoCopyWithImpl(this._self, this._then);

  final _StationDto _self;
  final $Res Function(_StationDto) _then;

/// Create a copy of StationDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? streams = null,Object? slug = freezed,Object? isActive = freezed,Object? logo = freezed,Object? dial = freezed,Object? aliases = freezed,Object? location = freezed,Object? genre = freezed,Object? popularity = freezed,Object? languages = freezed,}) {
  return _then(_StationDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,streams: null == streams ? _self._streams : streams // ignore: cast_nullable_to_non_nullable
as List<StreamDto>,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,dial: freezed == dial ? _self.dial : dial // ignore: cast_nullable_to_non_nullable
as StationDialDto?,aliases: freezed == aliases ? _self.aliases : aliases // ignore: cast_nullable_to_non_nullable
as StationAliasesDto?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as StationLocationDto?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as StationGenreDto?,popularity: freezed == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as StationPopularityDto?,languages: freezed == languages ? _self._languages : languages // ignore: cast_nullable_to_non_nullable
as List<StationLanguageDto>?,
  ));
}

/// Create a copy of StationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationDialDtoCopyWith<$Res>? get dial {
    if (_self.dial == null) {
    return null;
  }

  return $StationDialDtoCopyWith<$Res>(_self.dial!, (value) {
    return _then(_self.copyWith(dial: value));
  });
}/// Create a copy of StationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationAliasesDtoCopyWith<$Res>? get aliases {
    if (_self.aliases == null) {
    return null;
  }

  return $StationAliasesDtoCopyWith<$Res>(_self.aliases!, (value) {
    return _then(_self.copyWith(aliases: value));
  });
}/// Create a copy of StationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationLocationDtoCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $StationLocationDtoCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}/// Create a copy of StationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationGenreDtoCopyWith<$Res>? get genre {
    if (_self.genre == null) {
    return null;
  }

  return $StationGenreDtoCopyWith<$Res>(_self.genre!, (value) {
    return _then(_self.copyWith(genre: value));
  });
}/// Create a copy of StationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationPopularityDtoCopyWith<$Res>? get popularity {
    if (_self.popularity == null) {
    return null;
  }

  return $StationPopularityDtoCopyWith<$Res>(_self.popularity!, (value) {
    return _then(_self.copyWith(popularity: value));
  });
}
}

// dart format on
