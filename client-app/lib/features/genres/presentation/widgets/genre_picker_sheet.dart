import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../home/presentation/view_models/home_view_model.dart';
import '../view_models/genres_view_model.dart';
import 'genre_chip.dart';

class GenrePickerSheet extends StatefulWidget {
  const GenrePickerSheet({super.key});

  @override
  State<GenrePickerSheet> createState() => _GenrePickerSheetState();
}

class _GenrePickerSheetState extends State<GenrePickerSheet> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GenresViewModel>().load();
    });
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
      context.read<GenresViewModel>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final genres = context.watch<GenresViewModel>().state;
    final home = context.watch<HomeViewModel>();
    final activeId = home.state.activeGenreId;
    final media = MediaQuery.of(context);

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: media.size.height * 0.75),
      child: Container(
        color: AppColors.surfacePanelLight,
        padding: EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.xl,
          AppSpacing.xl + media.viewPadding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('SELECT GENRE', style: AppTypography.sectionLabel),
                const Spacer(),
                if (activeId != null)
                  TextButton(
                    onPressed: () {
                      home.clearGenre();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'CLEAR',
                      style: AppTypography.meta.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (genres.isLoading && genres.items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 1.5),
                  ),
                ),
              )
            else
              Flexible(
                child: SingleChildScrollView(
                  controller: _scrollCtrl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          for (final g in genres.items)
                            GenreChip(
                              label: g.name ?? g.slug ?? '#${g.id}',
                              active: g.id == activeId,
                              onTap: () {
                                home.applyGenre(
                                  g.id,
                                  g.name ?? g.slug ?? '#${g.id}',
                                );
                                Navigator.of(context).pop();
                              },
                            ),
                        ],
                      ),
                      if (genres.isLoadingMore)
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: AppSpacing.lg,
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
