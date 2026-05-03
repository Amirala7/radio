import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/core/errors/failures.dart';
import 'package:radio/features/favorites/domain/entities/favorite_station.dart';
import 'package:radio/features/favorites/domain/usecases/add_favorite_use_case.dart';
import 'package:radio/features/favorites/domain/usecases/remove_favorite_use_case.dart';
import 'package:radio/features/favorites/domain/usecases/toggle_favorite_use_case.dart';
import 'package:radio/features/favorites/domain/usecases/watch_favorites_use_case.dart';
import 'package:radio/features/favorites/presentation/view_models/favorites_view_model.dart';
import 'package:radio/features/stations/domain/entities/station.dart';

class _MockWatch extends Mock implements WatchFavoritesUseCase {}
class _MockAdd extends Mock implements AddFavoriteUseCase {}
class _MockRemove extends Mock implements RemoveFavoriteUseCase {}
class _MockToggle extends Mock implements ToggleFavoriteUseCase {}

void main() {
  late StreamController<List<FavoriteStation>> controller;
  late _MockWatch watch;
  late _MockAdd add;
  late _MockRemove remove;
  late _MockToggle toggle;
  late FavoritesViewModel vm;

  const station = Station(id: 42, name: 'Hot 97', streams: []);
  final fav = FavoriteStation(
    station: station,
    addedAt: DateTime.utc(2026, 5, 3),
  );

  setUpAll(() {
    registerFallbackValue(station);
  });

  setUp(() {
    controller = StreamController<List<FavoriteStation>>.broadcast();
    watch = _MockWatch();
    add = _MockAdd();
    remove = _MockRemove();
    toggle = _MockToggle();
    when(() => watch()).thenAnswer((_) => controller.stream);
    vm = FavoritesViewModel(
      watchFavorites: watch,
      addFavorite: add,
      removeFavorite: remove,
      toggleFavorite: toggle,
    );
  });

  tearDown(() async {
    vm.dispose();
    await controller.close();
  });

  test('initial state is loading with empty items', () {
    expect(vm.state.isLoading, true);
    expect(vm.state.items, isEmpty);
    expect(vm.state.error, isNull);
  });

  test('first emission flips isLoading false and populates items', () async {
    controller.add([fav]);
    await Future<void>.delayed(Duration.zero);

    expect(vm.state.isLoading, false);
    expect(vm.state.items, [fav]);
  });

  test('isFavorite reflects items', () async {
    controller.add([fav]);
    await Future<void>.delayed(Duration.zero);

    expect(vm.isFavorite(42), true);
    expect(vm.isFavorite(7), false);
  });

  test('add / remove / toggle call the matching use case', () async {
    when(() => add(any())).thenAnswer((_) async {});
    when(() => remove(any())).thenAnswer((_) async {});
    when(() => toggle(any())).thenAnswer((_) async {});

    await vm.add(station);
    await vm.remove(42);
    await vm.toggle(station);

    verify(() => add(station)).called(1);
    verify(() => remove(42)).called(1);
    verify(() => toggle(station)).called(1);
  });

  test('stream error populates state.error and preserves prior items',
      () async {
    controller.add([fav]);
    await Future<void>.delayed(Duration.zero);

    controller.addError(const NetworkFailure());
    await Future<void>.delayed(Duration.zero);

    expect(vm.state.error, isA<NetworkFailure>());
    expect(vm.state.items, [fav]); // preserved
  });

  test('dispose cancels the subscription and is idempotent', () async {
    vm.dispose();

    controller.add([fav]);
    await Future<void>.delayed(Duration.zero);

    // state did not update after dispose
    expect(vm.state.items, isEmpty);

    // dispose is idempotent (tearDown will call it again safely)
    expect(() => vm.dispose(), returnsNormally);
  });
}
