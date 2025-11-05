import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plc/features/parishes/domain/entities/parish.dart';
import 'package:plc/features/preachers/domain/entities/preacher.dart';
import 'package:plc/features/preachers/presentation/bloc/preacher_profile_bloc.dart';
import 'package:plc/features/preachers/presentation/bloc/preacher_profile_event.dart';
import 'package:plc/features/preachers/presentation/bloc/preacher_profile_state.dart';
import 'package:plc/theme/spacing.dart';

class ParishProfilePage extends StatefulWidget {
  final Parish parish;

  const ParishProfilePage({super.key, required this.parish});

  @override
  State<ParishProfilePage> createState() => _ParishProfilePageState();
}

class _ParishProfilePageState extends State<ParishProfilePage> {
  @override
  void initState() {
    super.initState();
    // context.read<ParishProfileBloc>().add(
    //       LoadParishProfile(id: widget.parish.id),
    //     );
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
      body: _buildProfileContent(context, widget.parish),
      // BlocBuilder<PreacherProfileBloc, PreacherProfileState>(
      //   builder: (context, state) {
      //     if (state is PreacherProfileLoading) {
      //       return Center(
      //         child: CircularProgressIndicator(
      //           color: Theme.of(context).colorScheme.primary,
      //         ),
      //       );
      //     } else if (state is PreacherProfileLoaded) {
      //       return _buildProfileContent(context, state.preacher);
      //     } else if (state is PreacherProfileError) {
      //       return _buildErrorState(context, state.message);
      //     }
      //     return Container();
      //   },
      // ),
    );
  }

  Widget _buildProfileContent(BuildContext context, Parish parish) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(defaultSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(150),
                    child: Image.network(
                      parish.imageUrl!,
                      width: 150,
                      height: 150,
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
                  ),
                  const SizedBox(height: 16),
                  Text(
                    parish.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    parish.location,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: defaultSpacing),

            // // Contact Information
            // Text(
            //   'Contato',
            //   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            //         color: Theme.of(context).colorScheme.primary,
            //         fontWeight: FontWeight.bold,
            //       ),
            // ),

            // const SizedBox(height: mediumSpacing),

            // _buildInfoCard(
            //   context,
            //   icon: Icons.phone,
            //   title: 'Telefone',
            //   value: preacher.phone.isNotEmpty == true
            //       ? preacher.phone
            //       : 'Não informado',
            // ),

            // const SizedBox(height: smallSpacing),

            // _buildInfoCard(
            //   context,
            //   icon: Icons.location_city,
            //   title: 'Paróquia / Cidade',
            //   value: preacher.city.isNotEmpty == true
            //       ? preacher.city
            //       : 'Não informado',
            // ),

            const SizedBox(height: defaultSpacing),

            // Preaching Themes Section
            // Container(
            //   width: double.infinity,
            //   padding: const EdgeInsets.all(defaultSpacing),
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       begin: Alignment.topLeft,
            //       end: Alignment.bottomRight,
            //       colors: [
            //         Theme.of(
            //           context,
            //         ).colorScheme.primary.withValues(alpha: 0.08),
            //         Theme.of(
            //           context,
            //         ).colorScheme.primary.withValues(alpha: 0.03),
            //       ],
            //     ),
            //     borderRadius: BorderRadius.circular(16),
            //     border: Border.all(
            //       color: Theme.of(
            //         context,
            //       ).colorScheme.primary.withValues(alpha: 0.15),
            //       width: 1.5,
            //     ),
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Row(
            //         children: [
            //           Container(
            //             padding: const EdgeInsets.all(smallSpacing),
            //             decoration: BoxDecoration(
            //               color: Theme.of(context).colorScheme.primary,
            //               borderRadius: BorderRadius.circular(8),
            //             ),
            //             child: const Icon(
            //               Icons.auto_stories,
            //               color: Colors.white,
            //               size: 24,
            //             ),
            //           ),
            //           const SizedBox(width: mediumSpacing),
            //           Expanded(
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(
            //                   'Temas de Pregação',
            //                   style: Theme.of(
            //                     context,
            //                   ).textTheme.titleLarge?.copyWith(
            //                         color:
            //                             Theme.of(context).colorScheme.primary,
            //                         fontWeight: FontWeight.bold,
            //                       ),
            //                 ),
            //                 Text(
            //                   '${preacher.themes.length} ${preacher.themes.length == 1 ? 'tema' : 'temas'}',
            //                   style: Theme.of(context)
            //                       .textTheme
            //                       .bodyMedium
            //                       ?.copyWith(color: Colors.grey[600]),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //       const SizedBox(height: defaultSpacing),
            //       if (preacher.themes.isEmpty)
            //         Center(
            //           child: Padding(
            //             padding: const EdgeInsets.symmetric(
            //               vertical: defaultSpacing,
            //             ),
            //             child: Column(
            //               children: [
            //                 Icon(
            //                   Icons.menu_book_outlined,
            //                   size: 48,
            //                   color: Theme.of(
            //                     context,
            //                   ).colorScheme.primary.withValues(alpha: 0.4),
            //                 ),
            //                 const SizedBox(height: smallSpacing),
            //                 Text(
            //                   'Nenhum tema cadastrado',
            //                   style: Theme.of(
            //                     context,
            //                   ).textTheme.titleMedium?.copyWith(
            //                         color:
            //                             Theme.of(context).colorScheme.primary,
            //                         fontWeight: FontWeight.w600,
            //                       ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         )
            //       else
            //         Wrap(
            //           spacing: smallSpacing,
            //           runSpacing: smallSpacing,
            //           children: preacher.themes
            //               .map(
            //                 (theme) => Container(
            //                   padding: const EdgeInsets.symmetric(
            //                     horizontal: mediumSpacing,
            //                     vertical: smallSpacing,
            //                   ),
            //                   decoration: BoxDecoration(
            //                     color: Colors.white,
            //                     borderRadius: BorderRadius.circular(20),
            //                     border: Border.all(
            //                       color: Theme.of(context)
            //                           .colorScheme
            //                           .primary
            //                           .withValues(alpha: 0.3),
            //                       width: 1.5,
            //                     ),
            //                     boxShadow: [
            //                       BoxShadow(
            //                         color: Theme.of(context)
            //                             .colorScheme
            //                             .primary
            //                             .withValues(alpha: 0.08),
            //                         blurRadius: 4,
            //                         offset: const Offset(0, 2),
            //                       ),
            //                     ],
            //                   ),
            //                   child: Text(
            //                     theme,
            //                     style: TextStyle(
            //                       color: Theme.of(context).colorScheme.primary,
            //                       fontWeight: FontWeight.w600,
            //                       fontSize: 14,
            //                     ),
            //                   ),
            //                 ),
            //               )
            //               .toList(),
            //         ),
            //     ],
            //   ),
            // ),
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
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(mediumSpacing),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: mediumSpacing),
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
                          color: Theme.of(context).colorScheme.primary,
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
                // context.read<PreacherProfileBloc>().add(
                //       LoadPreacherProfile(id: widget.preacherId),
                //     );
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
