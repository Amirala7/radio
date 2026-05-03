import 'package:flutter/foundation.dart';

import '../../../stations/presentation/view_models/stations_view_model.dart';
import 'home_state.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required StationsViewModel stations}) : _stations = stations;

  final StationsViewModel _stations;

  HomeState _state = const HomeState();
  HomeState get state => _state;

  /// Kicks off the initial fetch for the current tab. Call once from
  /// [HomeScreen.initState] (or anywhere the app boots).
  void bootstrap() => _refetchForCurrentTab();

  void setTab(HomeTab next) {
    _state = _state.copyWith(
      tab: next,
      isSearchOpen: false,
      searchQuery: '',
      activeGenreId: null,
      activeGenreName: null,
    );
    notifyListeners();
    _refetchForCurrentTab();
  }

  void openSearch() {
    if (_state.isSearchOpen) return;
    _state = _state.copyWith(isSearchOpen: true);
    notifyListeners();
  }

  void closeSearch() {
    if (!_state.isSearchOpen && _state.searchQuery.isEmpty) return;
    _state = _state.copyWith(isSearchOpen: false, searchQuery: '');
    notifyListeners();
    _refetchForCurrentTab();
  }

  void setSearchQuery(String query) {
    _state = _state.copyWith(searchQuery: query);
    notifyListeners();
    if (query.isEmpty) return;
    _stations.showSearch(query);
  }

  void applyGenre(int id, String name) {
    _state = _state.copyWith(activeGenreId: id, activeGenreName: name);
    notifyListeners();
    _stations.showByGenre(genreId: id);
  }

  void clearGenre() {
    if (_state.activeGenreId == null) return;
    _state = _state.copyWith(activeGenreId: null, activeGenreName: null);
    notifyListeners();
    _refetchForCurrentTab();
  }

  void _refetchForCurrentTab() {
    switch (_state.tab) {
      case HomeTab.popular:
        _stations.showPopular();
        break;
      case HomeTab.all:
        _stations.showList();
        break;
      case HomeTab.favorites:
        // No fetch — favourites is stream-driven.
        break;
    }
  }
}
