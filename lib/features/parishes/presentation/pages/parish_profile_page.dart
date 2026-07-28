import 'package:flutter/material.dart';
import 'package:plc/core/di/injection_container.dart';
import 'package:plc/features/parishes/data/repositories/members_repository_factory.dart';
import 'package:plc/features/parishes/domain/entities/member.dart';
import 'package:plc/features/parishes/domain/entities/parish.dart';
import 'package:plc/features/parishes/presentation/widgets/parish_members_view.dart';
import 'package:plc/theme/spacing.dart';

class ParishProfilePage extends StatefulWidget {
  final Parish parish;

  const ParishProfilePage({super.key, required this.parish});

  @override
  State<ParishProfilePage> createState() => _ParishProfilePageState();
}

class _ParishProfilePageState extends State<ParishProfilePage> {
  Future<List<Member>>? _members;

  @override
  void initState() {
    super.initState();
    final sheet = widget.parish.membersSheet;
    if (sheet != null) {
      _members = sl<MembersRepositoryFactory>().forSheet(sheet).getAll();
    }
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
                    child: parish.imageUrl != null
                        ? Image.network(
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
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.church,
                              color: Theme.of(context).colorScheme.primary,
                              size: 150,
                            ),
                          )
                        : Icon(
                            Icons.church,
                            color: Theme.of(context).colorScheme.primary,
                            size: 150,
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
            if (parish.perseverance.male != null)
              _buildInfoCard(
                context,
                icon: Icons.event_available,
                title: 'Perseverança masculina',
                value: parish.perseverance.male!,
                color: ParishMembersView.masculineColor,
              ),
            if (parish.perseverance.female != null)
              _buildInfoCard(
                context,
                icon: Icons.event_available,
                title: 'Perseverança feminina',
                value: parish.perseverance.female!,
                color: ParishMembersView.feminineColor,
              ),
            const SizedBox(height: defaultSpacing),
            _buildMembers(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMembers(BuildContext context) {
    if (_members == null) return const SizedBox.shrink();

    return FutureBuilder<List<Member>>(
      future: _members,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.only(bottom: defaultSpacing),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        // sem membros a página segue útil: horário e histórico já estão lá
        final members = snapshot.data;
        if (snapshot.hasError || members == null || members.isEmpty) {
          return const SizedBox.shrink();
        }
        return ParishMembersView(members: members);
      },
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    Color? color,
  }) {
    final cor = color ?? Theme.of(context).colorScheme.primary;

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
                color: cor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: cor, size: 20),
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
                          color: cor,
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
