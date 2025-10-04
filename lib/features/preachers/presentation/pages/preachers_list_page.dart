import 'package:plc/features/preachers/domain/entities/preacher.dart';
import 'package:plc/features/preachers/presentation/pages/preacher_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plc/features/preachers/presentation/bloc/preachers_bloc.dart';
import 'package:plc/features/preachers/presentation/bloc/preachers_event.dart';
import 'package:plc/features/preachers/presentation/bloc/preachers_state.dart';
import 'package:plc/features/preachers/presentation/widgets/search_bar.dart';
import 'package:plc/theme/spacing.dart';

class PreachersListPage extends StatefulWidget {
  const PreachersListPage({super.key});

  @override
  State<PreachersListPage> createState() => _PreachersListPageState();
}

class _PreachersListPageState extends State<PreachersListPage> {
  @override
  void initState() {
    super.initState();
    context.read<PreachersBloc>().add(LoadPreachers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.white,
        forceMaterialTransparency: true,
      ),
      body: BlocBuilder<PreachersBloc, PreachersState>(
        builder: (context, state) {
          if (state is PreachersLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          } else if (state is PreachersLoaded) {
            if (state.preachers.isEmpty && !state.inSearch) {
              return _buildEmptyState(context);
            }
            return _buildPreachersList(
              context,
              state.preachers,
              state.inSearch,
            );
          } else if (state is PreachersError) {
            return _buildErrorState(context, state.message);
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildPreachersList(
    BuildContext context,
    List<dynamic> preachers,
    bool inSearch,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Section
        Padding(
          padding: const EdgeInsets.only(
            left: mediumSpacing,
            right: mediumSpacing,
            bottom: mediumSpacing,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pregadores',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${preachers.length} pregadores ${inSearch ? 'encontrados' : 'ativos'}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: smallSpacing),
                        SearchPreachersBar(inSearch: inSearch),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Preachers List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: mediumSpacing),
            itemCount: preachers.length,
            itemBuilder: (context, index) {
              final preacher = preachers[index];
              return _buildPreacherCard(context, preacher);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPreacherCard(BuildContext context, Preacher preacher) {
    return Card(
      elevation: 0,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => PreacherProfilePage(preacherId: preacher.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: smallSpacing / 2,
            horizontal: smallSpacing,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 30,
                height: 30,
                child: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: smallSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      preacher.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: smallSpacing),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.primary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.people_outline,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Nenhum pregador encontrado',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'A lista de pregadores está sendo carregada ou ainda não há membros cadastrados.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.error_outline,
                size: 40,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Erro ao carregar pregadores',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<PreachersBloc>().add(LoadPreachers());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
