import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio/core/errors/failures.dart';
import 'package:radio/core/pagination/page.dart';
import 'package:radio/core/pagination/page_meta.dart';
import 'package:radio/features/genres/domain/entities/genre.dart';
import 'package:radio/features/genres/domain/usecases/list_genres_use_case.dart';
import 'package:radio/features/genres/presentation/view_models/genres_view_model.dart';

class _MockListGenres extends Mock implements ListGenresUseCase {}

Page<Genre> _pageOf(List<Genre> data, {int page = 1, int limit = 100}) =>
    Page<Genre>(data: data, meta: PageMeta(page: page, limit: limit));

void main() {
  late _MockListGenres listGenres;
  late GenresViewModel vm;

  const rock = Genre(id: 1, name: 'Rock');
  const jazz = Genre(id: 2, name: 'Jazz');

  setUp(() {
    listGenres = _MockListGenres();
    vm = GenresViewModel(listGenres: listGenres);
  });

  test('initial state', () {
    expect(vm.state.items, isEmpty);
    expect(vm.state.page, 1);
    expect(vm.state.limit, 100);
    expect(vm.state.hasMore, true);
  });

  test('load fetches page 1 and populates items', () async {
    when(() => listGenres(page: 1, limit: 100))
        .thenAnswer((_) async => _pageOf([rock, jazz]));

    await vm.load();

    expect(vm.state.items, [rock, jazz]);
    expect(vm.state.isLoading, false);
    expect(vm.state.hasMore, false); // returned 2 < limit 100
  });

  test('load is idempotent — second call without error is a no-op', () async {
    when(() => listGenres(page: 1, limit: 100))
        .thenAnswer((_) async => _pageOf([rock]));

    await vm.load();
    await vm.load();

    verify(() => listGenres(page: 1, limit: 100)).called(1);
  });

  test('refresh always re-fetches page 1', () async {
    when(() => listGenres(page: 1, limit: 100))
        .thenAnswer((_) async => _pageOf([rock]));
    await vm.load();

    when(() => listGenres(page: 1, limit: 100))
        .thenAnswer((_) async => _pageOf([rock, jazz]));
    await vm.refresh();

    expect(vm.state.items, [rock, jazz]);
    verify(() => listGenres(page: 1, limit: 100)).called(2);
  });

  test('loadMore appends next page and advances page', () async {
    final fullPage =
        List.generate(100, (i) => Genre(id: i, name: 'g$i'));
    when(() => listGenres(page: 1, limit: 100))
        .thenAnswer((_) async => _pageOf(fullPage));
    await vm.load();

    when(() => listGenres(page: 2, limit: 100))
        .thenAnswer((_) async => _pageOf([rock], page: 2));
    await vm.loadMore();

    expect(vm.state.page, 2);
    expect(vm.state.items.length, 101);
    expect(vm.state.hasMore, false);
  });

  test('failure populates error and clears loading; clearError clears it',
      () async {
    when(() => listGenres(page: 1, limit: 100))
        .thenThrow(const NetworkFailure());
    await vm.load();
    expect(vm.state.error, isA<NetworkFailure>());
    expect(vm.state.isLoading, false);

    vm.clearError();
    expect(vm.state.error, isNull);
  });
}
