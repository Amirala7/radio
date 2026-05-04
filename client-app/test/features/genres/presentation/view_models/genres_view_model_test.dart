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

  test('load fetches all pages until a short page ends the loop', () async {
    final fullPage = List.generate(100, (i) => Genre(id: i, name: 'g$i'));
    when(
      () => listGenres(page: 1, limit: 100),
    ).thenAnswer((_) async => _pageOf(fullPage));
    when(
      () => listGenres(page: 2, limit: 100),
    ).thenAnswer((_) async => _pageOf([rock, jazz], page: 2));

    await vm.load();

    expect(vm.state.items.length, 102);
    expect(vm.state.items.last, jazz);
    expect(vm.state.page, 2);
    expect(vm.state.hasMore, false);
    expect(vm.state.isLoading, false);
    verify(() => listGenres(page: 1, limit: 100)).called(1);
    verify(() => listGenres(page: 2, limit: 100)).called(1);
  });

  test('load short-circuits on subsequent calls once cached', () async {
    when(
      () => listGenres(page: 1, limit: 100),
    ).thenAnswer((_) async => _pageOf([rock]));

    await vm.load();
    await vm.load();
    await vm.load();

    verify(() => listGenres(page: 1, limit: 100)).called(1);
  });

  test('refresh re-fetches every page', () async {
    when(
      () => listGenres(page: 1, limit: 100),
    ).thenAnswer((_) async => _pageOf([rock]));
    await vm.load();

    when(
      () => listGenres(page: 1, limit: 100),
    ).thenAnswer((_) async => _pageOf([rock, jazz]));
    await vm.refresh();

    expect(vm.state.items, [rock, jazz]);
    verify(() => listGenres(page: 1, limit: 100)).called(2);
  });

  test('failure preserves any items already accumulated and clears loading', () async {
    final fullPage = List.generate(100, (i) => Genre(id: i, name: 'g$i'));
    when(
      () => listGenres(page: 1, limit: 100),
    ).thenAnswer((_) async => _pageOf(fullPage));
    when(
      () => listGenres(page: 2, limit: 100),
    ).thenThrow(const NetworkFailure());

    await vm.load();

    expect(vm.state.items.length, 100);
    expect(vm.state.error, isA<NetworkFailure>());
    expect(vm.state.isLoading, false);

    vm.clearError();
    expect(vm.state.error, isNull);
  });
}
