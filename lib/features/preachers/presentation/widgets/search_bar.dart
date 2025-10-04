import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plc/core/di/injection_container.dart';
import 'package:plc/features/preachers/presentation/bloc/preachers_bloc.dart';
import 'package:plc/features/preachers/presentation/bloc/preachers_event.dart';
import 'package:plc/features/preachers/presentation/bloc/preachers_state.dart';
import 'package:plc/features/preachers/presentation/widgets/theme_filter_dialog.dart';
import 'package:plc/features/preaching_themes/domain/usecases/get_preaching_themes.dart';
import 'package:plc/theme/spacing.dart';

class SearchPreachersBar extends StatefulWidget {
  const SearchPreachersBar({super.key, required this.inSearch});

  final bool inSearch;

  @override
  State<SearchPreachersBar> createState() => _SearchPreachersBarState();
}

class _SearchPreachersBarState extends State<SearchPreachersBar> {
  List<String> _availableThemes = [];
  bool _isLoadingThemes = false;

  @override
  void initState() {
    super.initState();
    _loadThemes();
  }

  Future<void> _loadThemes() async {
    setState(() {
      _isLoadingThemes = true;
    });

    try {
      final getPreachingThemes = sl<GetPreachingThemes>();
      final themes = await getPreachingThemes();
      setState(() {
        _availableThemes = themes;
        _isLoadingThemes = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingThemes = false;
      });
    }
  }

  void _showThemeFilterDialog(List<String> selectedThemes) async {
    final result = await showDialog<List<String>>(
      context: context,
      builder: (context) => ThemeFilterDialog(
        availableThemes: _availableThemes,
        selectedThemes: selectedThemes,
      ),
    );

    if (result != null && mounted) {
      context.read<PreachersBloc>().add(
        FilterPreachersByThemes(selectedThemes: result),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreachersBloc, PreachersState>(
      builder: (context, state) {
        final selectedThemes = state is PreachersLoaded ? state.selectedThemes : <String>[];

        return Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar pregador',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  filled: true,
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainer.withValues(alpha: 0.25),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: smallSpacing,
                    horizontal: smallSpacing,
                  ),
                ),
                onChanged: (value) {
                  context.read<PreachersBloc>().add(SearchPreachers(query: value));
                },
              ),
            ),
            const SizedBox(width: smallSpacing),
            IconButton(
              onPressed: _isLoadingThemes
                  ? null
                  : () => _showThemeFilterDialog(selectedThemes),
              icon: Badge(
                isLabelVisible: selectedThemes.isNotEmpty,
                label: Text('${selectedThemes.length}'),
                child: Icon(
                  Icons.filter_list,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              tooltip: 'Filtrar por temas',
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainer.withValues(alpha: 0.25),
              ),
            ),
          ],
        );
      },
    );
  }
}
