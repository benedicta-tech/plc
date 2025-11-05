import 'package:plc/core/presentation/page.dart';
import 'package:plc/features/parishes/domain/entities/parish.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plc/features/parishes/presentation/bloc/parishes_bloc.dart';
import 'package:plc/features/parishes/presentation/bloc/parishes_event.dart';
import 'package:plc/features/parishes/presentation/bloc/parishes_state.dart';
import 'package:plc/features/parishes/presentation/pages/parish_profile_page.dart';
import 'package:plc/theme/spacing.dart';

class ParishesListPage extends StatefulWidget {
  const ParishesListPage({super.key});

  @override
  State<ParishesListPage> createState() => _ParishesListPageState();
}

class _ParishesListPageState extends State<ParishesListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ParishesBloc>().add(LoadParishes());
  }

  @override
  Widget build(BuildContext context) {
    return CorePage(
      title: 'Paróquias',
      subtitle: 'Lista de paróquias com presença do PLC',
      child: BlocBuilder<ParishesBloc, ParishesState>(
        builder: (context, state) {
          if (state is ParishesLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          } else if (state is ParishesLoaded) {
            if (state.parishes.isEmpty) {
              return _buildEmptyState(context);
            }
            return _buildParishesList(context, state.parishes);
          } else if (state is ParishesError) {
            return _buildErrorState(context, state.message);
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildParishesList(
    BuildContext context,
    List<Parish> parishes,
  ) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.only(
              left: mediumSpacing, right: mediumSpacing, bottom: mediumSpacing),
          itemCount: parishes.length,
          itemBuilder: (context, index) {
            final parish = parishes[index];
            return _buildParishCard(context, parish);
          },
        ),
      )
    ]);
  }

  Widget _buildParishCard(BuildContext context, Parish parish) {
    return Card(
      elevation: 0,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ParishProfilePage(parish: parish),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: smallSpacing,
            horizontal: smallSpacing,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 30,
                height: 30,
                child: parish.imageUrl != null
                    ? ClipRRect(
                        borderRadius:
                            BorderRadius.circular(12 - smallSpacing / 2),
                        child: Image.network(
                          parish.imageUrl!,
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Icon(
                              Icons.church,
                              color: Theme.of(context).colorScheme.primary,
                              size: 18,
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.church,
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
                      parish.fullName,
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
              'Nenhuma paróquia encontrada',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'A lista de paróquias está sendo carregada ou ainda não há paróquias cadastradas.',
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
              'Erro ao carregar paróquias',
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
                context.read<ParishesBloc>().add(LoadParishes());
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
