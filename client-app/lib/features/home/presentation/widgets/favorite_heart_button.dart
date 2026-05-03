import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../favorites/presentation/view_models/favorites_view_model.dart';
import '../../../stations/domain/entities/station.dart';

class FavoriteHeartButton extends StatelessWidget {
  const FavoriteHeartButton({super.key, required this.station});

  final Station station;

  @override
  Widget build(BuildContext context) {
    return Selector<FavoritesViewModel, bool>(
      selector: (_, vm) => vm.isFavorite(station.id),
      builder: (context, isFavorite, _) {
        return InkWell(
          onTap: () => context.read<FavoritesViewModel>().toggle(station),
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 160),
              transitionBuilder: (child, anim) =>
                  FadeTransition(opacity: anim, child: child),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                key: ValueKey(isFavorite),
                size: 20,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        );
      },
    );
  }
}
