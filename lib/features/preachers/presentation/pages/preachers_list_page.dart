import 'package:plc/features/preachers/domain/entities/preacher.dart';
import 'package:plc/features/preachers/presentation/pages/preacher_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plc/features/preachers/presentation/bloc/preachers_bloc.dart';
import 'package:plc/features/preachers/presentation/bloc/preachers_event.dart';
import 'package:plc/features/preachers/presentation/bloc/preachers_state.dart';

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
        title: const Text(
          'Pregadores',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF083532),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<PreachersBloc, PreachersState>(
        builder: (context, state) {
          if (state is PreachersLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF083532)),
            );
          } else if (state is PreachersLoaded) {
            if (state.preachers.isEmpty) {
              return _buildEmptyState(context);
            }
            return _buildPreachersList(context, state.preachers);
          } else if (state is PreachersError) {
            return _buildErrorState(context, state.message);
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildPreachersList(BuildContext context, List<dynamic> preachers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Section
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF083532),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Icon(
                      Icons.people,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nossa Comunidade',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
                            color: const Color(0xFF083532),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${preachers.length} pregadores ativos',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
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
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            itemCount: preachers.length,
            itemBuilder: (context, index) {
              final preacher = preachers[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildPreacherCard(context, preacher),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPreacherCard(BuildContext context, Preacher preacher) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF083532).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFF083532),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      preacher.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF083532),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (preacher.city != null && preacher.city.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${preacher.city}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF083532),
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
                color: const Color(0xFF083532).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.people_outline,
                size: 40,
                color: Color(0xFF083532),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Nenhum pregador encontrado',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF083532),
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
                color: const Color(0xFF083532),
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
                backgroundColor: const Color(0xFF083532),
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
