import 'package:flutter/material.dart';
import 'package:plc/features/home/domain/entities/about_screen_section.dart';
import 'package:plc/theme/spacing.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plc/core/features/core_features.dart';

class AboutPLCPage extends StatefulWidget {
  const AboutPLCPage({super.key});

  @override
  State<AboutPLCPage> createState() => _AboutPLCPageState();
}

const iconMapping = {
  'favorite': Icons.favorite,
  'lightbulb_outline': Icons.lightbulb_outline,
  'flag': Icons.flag,
  'history': Icons.history,
  'people': Icons.people,
};

class _AboutPLCPageState extends State<AboutPLCPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<GenericListBloc<AboutScreenSection, String>>()
        .add(LoadItems());
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
          'Sobre a PLC',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: BlocBuilder<GenericListBloc<AboutScreenSection, String>,
          GenericListState<AboutScreenSection>>(
        builder: (context, state) {
          if (state is ListLoading<AboutScreenSection>) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          } else if (state is ListLoaded<AboutScreenSection, String>) {
            if (state.items.isEmpty) {
              return _buildErrorState(context, "Nenhum conteúdo disponível.");
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(defaultSpacing),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    Center(
                      child: Column(
                        children: [
                          const SizedBox(height: defaultSpacing),
                          Image(
                              image: AssetImage('images/plc.jpg'), height: 150),
                          const SizedBox(height: defaultSpacing),
                          Text(
                            'Movimento eclesial católico apostólico romano',
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.grey[600],
                                      fontStyle: FontStyle.italic,
                                    ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: defaultSpacing),

                    ...state.items.expand((section) => [
                          if (section.id == "finalidades")
                            _buildObjectivesSection(context, section: section)
                          else
                            _buildSection(
                              context,
                              title: section.title,
                              content: section.content.replaceAll('\\n', "\n"),
                              icon: iconMapping[section.icon] ?? Icons.info,
                            ),
                          const SizedBox(height: mediumSpacing),
                        ]),
                  ],
                ),
              ),
            );
          } else if (state is ListError<AboutScreenSection>) {
            return _buildErrorState(context, state.message);
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildObjectivesSection(BuildContext context,
      {required AboutScreenSection section}) {
    final objectives = section.content.split('\\n');

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(mediumSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.flag, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    section.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...objectives.asMap().entries.map((entry) {
              final index = entry.key;
              final objective = entry.value;

              return Padding(
                padding: const EdgeInsets.only(bottom: smallSpacing),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(right: 12, top: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        objective,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[700],
                              height: 1.5,
                            ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(mediumSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                    height: 1.6,
                  ),
              textAlign: TextAlign.justify,
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
              'Erro ao carregar conteúdo',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<GenericListBloc<AboutScreenSection, String>>().add(
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
