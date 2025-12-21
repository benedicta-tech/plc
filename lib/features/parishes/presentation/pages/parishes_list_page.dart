import 'package:plc/core/features/presentation/bloc/generic_list_bloc.dart';
import 'package:plc/core/features/presentation/bloc/generic_list_event.dart';
import 'package:plc/core/features/presentation/bloc/generic_list_state.dart';
import 'package:plc/features/parishes/domain/entities/parish.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    context.read<GenericListBloc<Parish, String>>().add(LoadItems());
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
        title: Text(
          'Paróquias',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: BlocBuilder<GenericListBloc<Parish, String>,
          GenericListState<Parish>>(
        builder: (context, state) {
          if (state is ListLoading<Parish>) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          } else if (state is ListLoaded<Parish, String>) {
            if (state.items.isEmpty) {
              return _buildEmptyState(context);
            }
            return _buildParishesList(context, state.items);
          } else if (state is ListError<Parish>) {
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
    return ListView(padding: const EdgeInsets.all(mediumSpacing), children: [
      Text(
        'Paróquias com atuação do movimento da PLC.',
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Colors.grey[600]),
      ),
      const SizedBox(height: mediumSpacing),
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: parishes
              .map((parish) => _buildParishCard(context, parish))
              .toList())
    ]);
  }

  Widget _buildParishCard(BuildContext context, Parish parish) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: smallSpacing),
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
          padding: const EdgeInsets.all(mediumSpacing),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: parish.imageUrl != null
                    ? ClipRRect(
                        borderRadius:
                            BorderRadius.circular(12 - smallSpacing / 2),
                        child: Image.network(
                          parish.imageUrl!,
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Icon(
                              Icons.church,
                              color: Theme.of(context).colorScheme.primary,
                              size: 24,
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.church,
                        color: Theme.of(context).colorScheme.primary,
                        size: 24,
                      ),
              ),
              const SizedBox(width: mediumSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      parish.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      parish.city,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: smallSpacing),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
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
                context.read<GenericListBloc<Parish, String>>().add(
                      LoadItems(),
                    );
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
