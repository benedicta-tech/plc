import 'package:flutter/material.dart';
import 'package:plc/features/parishes/domain/entities/parish.dart';
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
                    parish.city,
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
            parish.perseverance.male != null
                ? _buildInfoCard(
                    context,
                    icon: Icons.location_city,
                    title: 'Perseverança Masculina',
                    value: parish.perseverance.male != null
                        ? parish.perseverance.male!
                        : 'Não informado',
                  )
                : SizedBox.shrink(),
            parish.perseverance.female != null
                ? _buildInfoCard(
                    context,
                    icon: Icons.location_city,
                    title: 'Perseverança Feminina',
                    value: parish.perseverance.female != null
                        ? parish.perseverance.female!
                        : 'Não informado',
                  )
                : SizedBox.shrink(),
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
}
