import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

enum HomeTab { popular, all, favorites }

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(HomeTab.popular) HomeTab tab,
    @Default(false) bool isSearchOpen,
    @Default('') String searchQuery,
    int? activeGenreId,
    String? activeGenreName,
  }) = _HomeState;
}
