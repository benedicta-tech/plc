import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plc/features/preachers/presentation/bloc/preacher_profile_bloc.dart';
import 'package:plc/features/preachers/presentation/bloc/preacher_profile_event.dart';
import 'package:plc/features/preachers/presentation/bloc/preacher_profile_state.dart';

class PreacherProfilePage extends StatefulWidget {
  final int preacherId;

  const PreacherProfilePage({super.key, required this.preacherId});

  @override
  State<PreacherProfilePage> createState() => _PreacherProfilePageState();
}

class _PreacherProfilePageState extends State<PreacherProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<PreacherProfileBloc>().add(LoadPreacherProfile(id: widget.preacherId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Perfil do Pregador',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF083532),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<PreacherProfileBloc, PreacherProfileState>(
        builder: (context, state) {
          if (state is PreacherProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF083532),
              ),
            );
          } else if (state is PreacherProfileLoaded) {
            return _buildProfileContent(context, state.preacher);
          } else if (state is PreacherProfileError) {
            return _buildErrorState(context, state.message);
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, dynamic preacher) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF083532),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    preacher.fullName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: const Color(0xFF083532),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Membro da Comunidade PLC',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Contact Information
            Text(
              'Informações de Contato',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF083532),
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            _buildInfoCard(
              context,
              icon: Icons.phone,
              title: 'Telefone',
              value: preacher.phone?.isNotEmpty == true ? preacher.phone : 'Não informado',
            ),
            
            const SizedBox(height: 12),
            
            _buildInfoCard(
              context,
              icon: Icons.location_city,
              title: 'Cidade',
              value: preacher.city?.isNotEmpty == true ? preacher.city : 'Não informado',
            ),
            
            const SizedBox(height: 12),
            
            _buildInfoCard(
              context,
              icon: Icons.map,
              title: 'Estado',
              value: preacher.state?.isNotEmpty == true ? preacher.state : 'Não informado',
            ),
            
            const SizedBox(height: 32),
            
            // Preaching Themes Section
            Text(
              'Temas de Pregação',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF083532),
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF083532).withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF083532).withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.menu_book,
                    size: 40,
                    color: const Color(0xFF083532).withValues(alpha: 0.6),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Temas em desenvolvimento',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF083532),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Esta seção mostrará os temas de pregação associados a este membro.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF083532).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF083532),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF083532),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
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
              'Erro ao carregar perfil',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF083532),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<PreacherProfileBloc>().add(
                  LoadPreacherProfile(id: widget.preacherId),
                );
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
