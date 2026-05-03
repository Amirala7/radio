import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/core/pagination/page.dart';
import 'package:radio/core/pagination/page_meta.dart';
import 'package:radio/features/stations/domain/entities/station.dart';
import 'package:radio/features/stations/domain/usecases/get_popular_stations_use_case.dart';
import 'package:radio/features/stations/domain/usecases/get_stations_by_genre_use_case.dart';
import 'package:radio/features/stations/domain/usecases/list_stations_use_case.dart';
import 'package:radio/features/stations/domain/usecases/search_stations_use_case.dart';
import 'package:radio/features/stations/presentation/view_models/stations_state.dart';
import 'package:radio/features/stations/presentation/view_models/stations_view_model.dart';

class _MockListStations extends Mock implements ListStationsUseCase {}
class _MockPopular extends Mock implements GetPopularStationsUseCase {}
class _MockSearch extends Mock implements SearchStationsUseCase {}
class _MockByGenre extends Mock implements GetStationsByGenreUseCase {}

Page<Station> _pageOf(List<Station> data, {int page = 1, int limit = 20}) =>
    Page<Station>(data: data, meta: PageMeta(page: page, limit: limit));

void main() {
  late _MockListStations listStations;
  late _MockPopular popular;
  late _MockSearch search;
  late _MockByGenre byGenre;
  late StationsViewModel vm;

  const a = Station(id: 1, name: 'A', streams: []);
  const b = Station(id: 2, name: 'B', streams: []);

  setUp(() {
    listStations = _MockListStations();
    popular = _MockPopular();
    search = _MockSearch();
    byGenre = _MockByGenre();
    vm = StationsViewModel(
      listStations: listStations,
      popularStations: popular,
      searchStations: search,
      stationsByGenre: byGenre,
    );
  });

  test('initial state defaults', () {
    expect(vm.state.mode, StationsMode.list);
    expect(vm.state.items, isEmpty);
    expect(vm.state.page, 1);
    expect(vm.state.limit, 20);
    expect(vm.state.isLoading, false);
    expect(vm.state.isLoadingMore, false);
    expect(vm.state.hasMore, true);
    expect(vm.state.error, isNull);
  });

  test('showList fetches page 1 in list mode and populates items', () async {
    when(() => listStations(page: 1, limit: 20))
        .thenAnswer((_) async => _pageOf([a, b]));

    await vm.showList();

    expect(vm.state.mode, StationsMode.list);
    expect(vm.state.items, [a, b]);
    expect(vm.state.page, 1);
    expect(vm.state.isLoading, false);
    expect(vm.state.hasMore, false); // returned 2 < limit 20
    verify(() => listStations(page: 1, limit: 20)).called(1);
  });

  test('showPopular forwards country and switches mode', () async {
    when(() => popular(country: 'GB', page: 1, limit: 20))
        .thenAnswer((_) async => _pageOf([a]));

    await vm.showPopular(country: 'GB');

    expect(vm.state.mode, StationsMode.popular);
    expect(vm.state.country, 'GB');
    expect(vm.state.items, [a]);
    verify(() => popular(country: 'GB', page: 1, limit: 20)).called(1);
  });

  test('showSearch with empty query is a no-op', () async {
    await vm.showSearch('');
    expect(vm.state.mode, StationsMode.list); // unchanged
    verifyZeroInteractions(search);
  });

  test('showSearch sets query, switches mode, and fetches', () async {
    when(() => search(query: 'jazz', page: 1, limit: 20))
        .thenAnswer((_) async => _pageOf([b]));

    await vm.showSearch('jazz');

    expect(vm.state.mode, StationsMode.search);
    expect(vm.state.query, 'jazz');
    expect(vm.state.items, [b]);
  });

  test('showByGenre forwards id and slug', () async {
    when(() => byGenre(genreId: 7, genreSlug: null, page: 1, limit: 20))
        .thenAnswer((_) async => _pageOf([a]));

    await vm.showByGenre(genreId: 7);

    expect(vm.state.mode, StationsMode.byGenre);
    expect(vm.state.genreId, 7);
    expect(vm.state.items, [a]);
  });
}
