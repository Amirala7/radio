import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../genres/presentation/view_models/genres_view_model.dart';
import '../../../genres/presentation/widgets/genre_picker_sheet.dart';
import '../../../player/presentation/widgets/hardware_panel.dart';
import '../view_models/home_state.dart';
import '../view_models/home_view_model.dart';
import '../widgets/app_header.dart';
import '../widgets/filter_bar.dart';
import '../widgets/search_field.dart';
import '../widgets/section_label.dart';
import '../widgets/stations_list_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<HomeViewModel>().bootstrap();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.surfaceBody,
    body: SafeArea(
      bottom: false,
      child: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppHeader(),
                FilterBar(onOpenGenres: () => _openGenres(context)),
                const SearchField(),
                const _SectionLabelForState(),
                const Expanded(child: StationsListView()),
              ],
            ),
          ),
          const HardwarePanel(),
        ],
      ),
    ),
  );

  void _openGenres(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => MultiProvider(
        providers: [
          ChangeNotifierProvider<GenresViewModel>.value(
            value: context.read<GenresViewModel>(),
          ),
          ChangeNotifierProvider<HomeViewModel>.value(
            value: context.read<HomeViewModel>(),
          ),
        ],
        child: const GenrePickerSheet(),
      ),
    );
  }
}

class _SectionLabelForState extends StatelessWidget {
  const _SectionLabelForState();

  @override
  Widget build(BuildContext context) {
    final home = context.watch<HomeViewModel>();
    String text;
    if (home.state.isSearchOpen && home.state.searchQuery.isNotEmpty) {
      text = 'SEARCH RESULTS';
    } else if (home.state.activeGenreName != null) {
      text = home.state.activeGenreName!;
    } else {
      switch (home.state.tab) {
        case HomeTab.popular:
          text = 'POPULAR STATIONS';
          break;
        case HomeTab.all:
          text = 'ALL STATIONS';
          break;
        case HomeTab.favorites:
          text = 'FAVORITES';
          break;
      }
    }
    return SectionLabel(text: text);
  }
}
