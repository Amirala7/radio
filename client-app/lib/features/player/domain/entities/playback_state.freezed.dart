// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playback_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlaybackState {

 PlaybackStatus get status; Station? get currentStation; RadioStream? get currentStream; Duration get position; Duration get bufferedPosition; bool get isBuffering; AppFailure? get error;
/// Create a copy of PlaybackState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaybackStateCopyWith<PlaybackState> get copyWith => _$PlaybackStateCopyWithImpl<PlaybackState>(this as PlaybackState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaybackState&&(identical(other.status, status) || other.status == status)&&(identical(other.currentStation, currentStation) || other.currentStation == currentStation)&&(identical(other.currentStream, currentStream) || other.currentStream == currentStream)&&(identical(other.position, position) || other.position == position)&&(identical(other.bufferedPosition, bufferedPosition) || other.bufferedPosition == bufferedPosition)&&(identical(other.isBuffering, isBuffering) || other.isBuffering == isBuffering)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,status,currentStation,currentStream,position,bufferedPosition,isBuffering,error);

@override
String toString() {
  return 'PlaybackState(status: $status, currentStation: $currentStation, currentStream: $currentStream, position: $position, bufferedPosition: $bufferedPosition, isBuffering: $isBuffering, error: $error)';
}


}

/// @nodoc
abstract mixin class $PlaybackStateCopyWith<$Res>  {
  factory $PlaybackStateCopyWith(PlaybackState value, $Res Function(PlaybackState) _then) = _$PlaybackStateCopyWithImpl;
@useResult
$Res call({
 PlaybackStatus status, Station? currentStation, RadioStream? currentStream, Duration position, Duration bufferedPosition, bool isBuffering, AppFailure? error
});


$StationCopyWith<$Res>? get currentStation;$RadioStreamCopyWith<$Res>? get currentStream;

}
/// @nodoc
class _$PlaybackStateCopyWithImpl<$Res>
    implements $PlaybackStateCopyWith<$Res> {
  _$PlaybackStateCopyWithImpl(this._self, this._then);

  final PlaybackState _self;
  final $Res Function(PlaybackState) _then;

/// Create a copy of PlaybackState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? currentStation = freezed,Object? currentStream = freezed,Object? position = null,Object? bufferedPosition = null,Object? isBuffering = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PlaybackStatus,currentStation: freezed == currentStation ? _self.currentStation : currentStation // ignore: cast_nullable_to_non_nullable
as Station?,currentStream: freezed == currentStream ? _self.currentStream : currentStream // ignore: cast_nullable_to_non_nullable
as RadioStream?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,bufferedPosition: null == bufferedPosition ? _self.bufferedPosition : bufferedPosition // ignore: cast_nullable_to_non_nullable
as Duration,isBuffering: null == isBuffering ? _self.isBuffering : isBuffering // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}
/// Create a copy of PlaybackState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationCopyWith<$Res>? get currentStation {
    if (_self.currentStation == null) {
    return null;
  }

  return $StationCopyWith<$Res>(_self.currentStation!, (value) {
    return _then(_self.copyWith(currentStation: value));
  });
}/// Create a copy of PlaybackState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RadioStreamCopyWith<$Res>? get currentStream {
    if (_self.currentStream == null) {
    return null;
  }

  return $RadioStreamCopyWith<$Res>(_self.currentStream!, (value) {
    return _then(_self.copyWith(currentStream: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlaybackState].
extension PlaybackStatePatterns on PlaybackState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlaybackState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlaybackState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlaybackState value)  $default,){
final _that = this;
switch (_that) {
case _PlaybackState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlaybackState value)?  $default,){
final _that = this;
switch (_that) {
case _PlaybackState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PlaybackStatus status,  Station? currentStation,  RadioStream? currentStream,  Duration position,  Duration bufferedPosition,  bool isBuffering,  AppFailure? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlaybackState() when $default != null:
return $default(_that.status,_that.currentStation,_that.currentStream,_that.position,_that.bufferedPosition,_that.isBuffering,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PlaybackStatus status,  Station? currentStation,  RadioStream? currentStream,  Duration position,  Duration bufferedPosition,  bool isBuffering,  AppFailure? error)  $default,) {final _that = this;
switch (_that) {
case _PlaybackState():
return $default(_that.status,_that.currentStation,_that.currentStream,_that.position,_that.bufferedPosition,_that.isBuffering,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PlaybackStatus status,  Station? currentStation,  RadioStream? currentStream,  Duration position,  Duration bufferedPosition,  bool isBuffering,  AppFailure? error)?  $default,) {final _that = this;
switch (_that) {
case _PlaybackState() when $default != null:
return $default(_that.status,_that.currentStation,_that.currentStream,_that.position,_that.bufferedPosition,_that.isBuffering,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _PlaybackState implements PlaybackState {
  const _PlaybackState({this.status = PlaybackStatus.idle, this.currentStation, this.currentStream, this.position = Duration.zero, this.bufferedPosition = Duration.zero, this.isBuffering = false, this.error});
  

@override@JsonKey() final  PlaybackStatus status;
@override final  Station? currentStation;
@override final  RadioStream? currentStream;
@override@JsonKey() final  Duration position;
@override@JsonKey() final  Duration bufferedPosition;
@override@JsonKey() final  bool isBuffering;
@override final  AppFailure? error;

/// Create a copy of PlaybackState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaybackStateCopyWith<_PlaybackState> get copyWith => __$PlaybackStateCopyWithImpl<_PlaybackState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlaybackState&&(identical(other.status, status) || other.status == status)&&(identical(other.currentStation, currentStation) || other.currentStation == currentStation)&&(identical(other.currentStream, currentStream) || other.currentStream == currentStream)&&(identical(other.position, position) || other.position == position)&&(identical(other.bufferedPosition, bufferedPosition) || other.bufferedPosition == bufferedPosition)&&(identical(other.isBuffering, isBuffering) || other.isBuffering == isBuffering)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,status,currentStation,currentStream,position,bufferedPosition,isBuffering,error);

@override
String toString() {
  return 'PlaybackState(status: $status, currentStation: $currentStation, currentStream: $currentStream, position: $position, bufferedPosition: $bufferedPosition, isBuffering: $isBuffering, error: $error)';
}


}

/// @nodoc
abstract mixin class _$PlaybackStateCopyWith<$Res> implements $PlaybackStateCopyWith<$Res> {
  factory _$PlaybackStateCopyWith(_PlaybackState value, $Res Function(_PlaybackState) _then) = __$PlaybackStateCopyWithImpl;
@override @useResult
$Res call({
 PlaybackStatus status, Station? currentStation, RadioStream? currentStream, Duration position, Duration bufferedPosition, bool isBuffering, AppFailure? error
});


@override $StationCopyWith<$Res>? get currentStation;@override $RadioStreamCopyWith<$Res>? get currentStream;

}
/// @nodoc
class __$PlaybackStateCopyWithImpl<$Res>
    implements _$PlaybackStateCopyWith<$Res> {
  __$PlaybackStateCopyWithImpl(this._self, this._then);

  final _PlaybackState _self;
  final $Res Function(_PlaybackState) _then;

/// Create a copy of PlaybackState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? currentStation = freezed,Object? currentStream = freezed,Object? position = null,Object? bufferedPosition = null,Object? isBuffering = null,Object? error = freezed,}) {
  return _then(_PlaybackState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PlaybackStatus,currentStation: freezed == currentStation ? _self.currentStation : currentStation // ignore: cast_nullable_to_non_nullable
as Station?,currentStream: freezed == currentStream ? _self.currentStream : currentStream // ignore: cast_nullable_to_non_nullable
as RadioStream?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,bufferedPosition: null == bufferedPosition ? _self.bufferedPosition : bufferedPosition // ignore: cast_nullable_to_non_nullable
as Duration,isBuffering: null == isBuffering ? _self.isBuffering : isBuffering // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}

/// Create a copy of PlaybackState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationCopyWith<$Res>? get currentStation {
    if (_self.currentStation == null) {
    return null;
  }

  return $StationCopyWith<$Res>(_self.currentStation!, (value) {
    return _then(_self.copyWith(currentStation: value));
  });
}/// Create a copy of PlaybackState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RadioStreamCopyWith<$Res>? get currentStream {
    if (_self.currentStream == null) {
    return null;
  }

  return $RadioStreamCopyWith<$Res>(_self.currentStream!, (value) {
    return _then(_self.copyWith(currentStream: value));
  });
}
}

// dart format on
