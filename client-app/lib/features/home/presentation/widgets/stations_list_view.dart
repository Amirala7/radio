import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../favorites/presentation/view_models/favorites_view_model.dart';
import '../../../stations/domain/entities/station.dart';
import '../../../stations/presentation/view_models/stations_view_model.dart';
import '../view_models/home_state.dart';
import '../view_models/home_view_model.dart';
import 'empty_state.dart';
import 'station_row.dart';

String _failureMessage(AppFailure f) => switch (f) {
  NetworkFailure() => 'Network error.',
  UnauthenticatedFailure() => 'Not signed in.',
  InvalidArgumentFailure(:final message) => message,
  UnknownFailure(:final message) => message,
};

class StationsListView extends StatefulWidget {
  const StationsListView({super.key});

  @override
  State<StationsListView> createState() => _StationsListViewState();
}

class _StationsListViewState extends State<StationsListView> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollCtrl.hasClients) return;
    final pos = _scrollCtrl.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      final home = context.read<HomeViewModel>();
      if (home.state.tab != HomeTab.favorites) {
        context.read<StationsViewModel>().loadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final home = context.watch<HomeViewModel>();
    final useFavorites =
        home.state.tab == HomeTab.favorites &&
        !(home.state.isSearchOpen && home.state.searchQuery.isNotEmpty) &&
        home.state.activeGenreId == null;

    if (useFavorites) {
      final favorites = context.watch<FavoritesViewModel>().state;
      if (favorites.error != null && favorites.items.isEmpty) {
        return EmptyState(
          headline: 'SIGNAL LOST',
          body: _failureMessage(favorites.error!),
        );
      }
      if (favorites.items.isEmpty && !favorites.isLoading) {
        return const EmptyState(
          headline: 'NO FAVORITES YET',
          body: 'Tap the heart on a station to save it.',
        );
      }
      return _buildList(
        context,
        items: favorites.items.map((f) => f.station).toList(),
        isLoading: favorites.isLoading,
        isLoadingMore: false,
        hasMore: false,
        onRefresh: null,
      );
    }

    final stations = context.watch<StationsViewModel>().state;
    if (stations.error != null && stations.items.isEmpty) {
      return EmptyState(
        headline: 'SIGNAL LOST',
        body: _failureMessage(stations.error!),
        onRetry: () => context.read<StationsViewModel>().refresh(),
      );
    }
    if (stations.items.isEmpty && !stations.isLoading) {
      if (home.state.isSearchOpen && home.state.searchQuery.isNotEmpty) {
        return const EmptyState(
          headline: 'NO RESULTS',
          body: 'Try a different keyword.',
        );
      }
      return const EmptyState(
        headline: 'NOTHING TO SHOW',
        body: 'Pull down to refresh.',
      );
    }
    if (stations.items.isEmpty && stations.isLoading) {
      return const Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 1.5),
        ),
      );
    }

    return _buildList(
      context,
      items: stations.items,
      isLoading: stations.isLoading,
      isLoadingMore: stations.isLoadingMore,
      hasMore: stations.hasMore,
      onRefresh: () => context.read<StationsViewModel>().refresh(),
    );
  }

  Widget _buildList(
    BuildContext context, {
    required List<Station> items,
    required bool isLoading,
    required bool isLoadingMore,
    required bool hasMore,
    required Future<void> Function()? onRefresh,
  }) {
    final body = ListView.separated(
      controller: _scrollCtrl,
      itemCount: items.length + 1, // +1 for footer
      separatorBuilder: (_, _) => const Divider(),
      itemBuilder: (_, i) {
        if (i == items.length) {
          return _Footer(
            isLoadingMore: isLoadingMore,
            hasMore: hasMore,
            hasItems: items.isNotEmpty,
          );
        }
        return StationRow(station: items[i]);
      },
    );
    if (onRefresh == null) return body;
    return RefreshIndicator(onRefresh: onRefresh, child: body);
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.isLoadingMore,
    required this.hasMore,
    required this.hasItems,
  });

  final bool isLoadingMore;
  final bool hasMore;
  final bool hasItems;

  @override
  Widget build(BuildContext context) {
    if (isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 1.5),
          ),
        ),
      );
    }
    if (!hasMore && hasItems) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: Center(
          child: Text(
            'END OF LIST',
            style: AppTypography.meta.copyWith(color: AppColors.textSecondary),
          ),
        ),
      );
    }
    return const SizedBox(height: AppSpacing.xl);
  }
}
