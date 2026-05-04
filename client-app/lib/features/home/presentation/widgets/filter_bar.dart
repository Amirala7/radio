import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../view_models/home_state.dart';
import '../view_models/home_view_model.dart';

class FilterBar extends StatelessWidget {
  const FilterBar({super.key, required this.onOpenGenres});

  final VoidCallback onOpenGenres;

  @override
  Widget build(BuildContext context) {
    final home = context.watch<HomeViewModel>();
    final isSearchActive =
        home.state.isSearchOpen && home.state.searchQuery.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          _TabLabel(
            text: 'POPULAR',
            active: !isSearchActive && home.state.tab == HomeTab.popular,
            onTap: () => home.setTab(HomeTab.popular),
          ),
          const SizedBox(width: AppSpacing.lg),
          _TabLabel(
            text: 'ALL',
            active: !isSearchActive && home.state.tab == HomeTab.all,
            onTap: () => home.setTab(HomeTab.all),
          ),
          const SizedBox(width: AppSpacing.lg),
          _TabLabel(
            text: 'FAVORITES',
            active: !isSearchActive && home.state.tab == HomeTab.favorites,
            onTap: () => home.setTab(HomeTab.favorites),
          ),
          const Spacer(),
          IconButton(
            iconSize: 22,
            color: AppColors.textPrimary,
            icon: const Icon(Icons.search),
            onPressed: () {
              if (home.state.isSearchOpen) {
                home.closeSearch();
              } else {
                home.openSearch();
              }
            },
          ),
          IconButton(
            iconSize: 22,
            color: AppColors.textPrimary,
            icon: const Icon(Icons.tune),
            onPressed: onOpenGenres,
          ),
        ],
      ),
    );
  }
}

class _TabLabel extends StatelessWidget {
  const _TabLabel({
    required this.text,
    required this.active,
    required this.onTap,
  });

  final String text;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    customBorder: const StadiumBorder(),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (active) ...[
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.accentLive,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            text,
            style: AppTypography.meta.copyWith(
              color: active ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    ),
  );
}
