import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/features/home/presentation/view_models/home_state.dart';
import 'package:radio/features/home/presentation/view_models/home_view_model.dart';
import 'package:radio/features/stations/presentation/view_models/stations_view_model.dart';

class _MockStations extends Mock implements StationsViewModel {}

void main() {
  late _MockStations stations;
  late HomeViewModel vm;

  setUp(() {
    stations = _MockStations();
    when(
      () => stations.showPopular(
        country: any(named: 'country'),
        useCacheIfFresh: any(named: 'useCacheIfFresh'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => stations.showList(
        useCacheIfFresh: any(named: 'useCacheIfFresh'),
      ),
    ).thenAnswer((_) async {});
    when(() => stations.showSearch(any())).thenAnswer((_) async {});
    when(
      () => stations.showByGenre(
        genreId: any(named: 'genreId'),
        genreSlug: any(named: 'genreSlug'),
      ),
    ).thenAnswer((_) async {});
    vm = HomeViewModel(stations: stations);
  });

  test('constructor does not trigger any fetch', () {
    verifyNever(
      () => stations.showPopular(
        country: any(named: 'country'),
        useCacheIfFresh: any(named: 'useCacheIfFresh'),
      ),
    );
    verifyNever(
      () => stations.showList(
        useCacheIfFresh: any(named: 'useCacheIfFresh'),
      ),
    );
    verifyNever(() => stations.showSearch(any()));
  });

  test('initial state: popular tab, search closed, no genre', () {
    expect(vm.state.tab, HomeTab.popular);
    expect(vm.state.isSearchOpen, false);
    expect(vm.state.searchQuery, '');
    expect(vm.state.activeGenreId, null);
  });

  test('bootstrap fetches the default tab feed (popular) without cache', () {
    vm.bootstrap();
    verify(() => stations.showPopular(useCacheIfFresh: false)).called(1);
  });

  test('setTab(all) calls showList with cache flag and updates tab', () {
    vm.setTab(HomeTab.all);
    expect(vm.state.tab, HomeTab.all);
    verify(() => stations.showList(useCacheIfFresh: true)).called(1);
  });

  test('setTab(popular) calls showPopular with cache flag and updates tab', () {
    vm.setTab(HomeTab.all);
    vm.setTab(HomeTab.popular);
    expect(vm.state.tab, HomeTab.popular);
    verify(() => stations.showPopular(useCacheIfFresh: true)).called(1);
  });

  test('setTab(favorites) does not call any stations fetch', () {
    vm.setTab(HomeTab.favorites);
    expect(vm.state.tab, HomeTab.favorites);
    verifyNever(
      () => stations.showList(
        useCacheIfFresh: any(named: 'useCacheIfFresh'),
      ),
    );
    verifyNever(
      () => stations.showPopular(
        country: any(named: 'country'),
        useCacheIfFresh: any(named: 'useCacheIfFresh'),
      ),
    );
  });

  test('setTab clears search and active genre', () {
    vm.openSearch();
    vm.setSearchQuery('jazz');
    vm.applyGenre(7, 'JAZZ');

    vm.setTab(HomeTab.all);

    expect(vm.state.isSearchOpen, false);
    expect(vm.state.searchQuery, '');
    expect(vm.state.activeGenreId, null);
    expect(vm.state.activeGenreName, null);
  });

  test('openSearch sets isSearchOpen true', () {
    vm.openSearch();
    expect(vm.state.isSearchOpen, true);
  });

  test('closeSearch clears query and restores feed', () {
    vm.openSearch();
    vm.setSearchQuery('foo');

    vm.closeSearch();

    expect(vm.state.isSearchOpen, false);
    expect(vm.state.searchQuery, '');
    verify(() => stations.showPopular(useCacheIfFresh: false)).called(1);
  });

  test('setSearchQuery non-empty triggers search', () {
    vm.openSearch();
    vm.setSearchQuery('jazz');
    verify(() => stations.showSearch('jazz')).called(1);
  });

  test('setSearchQuery empty does not trigger search', () {
    vm.openSearch();
    vm.setSearchQuery('');
    verifyNever(() => stations.showSearch(any()));
  });

  test('applyGenre triggers showByGenre and updates state', () {
    vm.applyGenre(42, 'TECHNO');
    expect(vm.state.activeGenreId, 42);
    expect(vm.state.activeGenreName, 'TECHNO');
    verify(() => stations.showByGenre(genreId: 42)).called(1);
  });

  test('clearGenre restores feed for current tab without cache', () {
    vm.applyGenre(42, 'TECHNO');

    vm.clearGenre();

    expect(vm.state.activeGenreId, null);
    expect(vm.state.activeGenreName, null);
    verify(() => stations.showPopular(useCacheIfFresh: false)).called(1);
  });
}
