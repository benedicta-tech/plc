import 'package:flutter/material.dart';
import 'package:plc/theme/spacing.dart';

class AboutPLCPage extends StatelessWidget {
  const AboutPLCPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Sobre a PLC',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                    Image(image: AssetImage('images/plc.jpg'), height: 150),
                    const SizedBox(height: defaultSpacing),
                    Text(
                      'Movimento eclesial católico apostólico romano',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: defaultSpacing),

              _buildSection(
                context,
                title: 'Coordenação',
                content:
                    'Assessor Diocesano - Pe. Joaquim Rocha de Calais\n\nCoordenador Diocesano:\nPLC Masculino - Geraldo Malcélio \nPLC Feminino - Maria Angélica ',
                icon: Icons.people,
              ),
              const SizedBox(height: mediumSpacing),

              // Mission Section
              _buildSection(
                context,
                title: 'Denominação',
                content:
                    'A PLC - Peregrinação de Leigos Cristãos é um Movimento Eclesial Católico Apostólico Romano, constituído por tempo indeterminado, sem fins lucrativos, sujeita à assessoria eclesiástica do pároco e do Conselho de Pastoral Paroquial, a nível paroquial e do bispo em sua atuação na Igreja particular em nível Diocesano.\n\nA missão da PLC consiste em propagar a mensagem cristã, a doutrinada Igreja da Católica Apostólica Romana e as diretrizes de evangelização diocesanas, de maneira catequética e testemunhal, às pessoas que participam dos cursos, das reuniões de perseverança e demais atividades segundo os preceitos evangélicos.',
                icon: Icons.favorite,
              ),

              const SizedBox(height: mediumSpacing),

              // Purpose Section
              _buildSection(
                context,
                title: 'Missão',
                content:
                    'A PLC cumpre com a sua missão através de sua finalidade pastoral específica que é evangelização de maneira catequética, levando os seus membros, a tornarem-se aptos a anunciar a Boa Nova, através de um encontro consigo mesmos, com Jesus Cristo e com as realidades do mundo nas quais estão imersos, sendo, no seio delas, tanto pessoal como comunitariamente, fermento que transforma sal que dá sabor e luz que ilumina, segundo os preceitos do Evangelho.',
                icon: Icons.lightbulb_outline,
              ),

              const SizedBox(height: mediumSpacing),

              // Objectives Section
              _buildObjectivesSection(context),

              const SizedBox(height: mediumSpacing),

              // History Section
              _buildSection(
                context,
                title: 'História',
                content:
                    'Teve inicio em 1969 na cidade de Jaú estado de São Paulo e com a finalidade principal unir as famílias que estão em atrito e busca de pessoas que estão afastadas do meio religioso e inseri-las nas igrejas de comunidades.',
                icon: Icons.history,
              ),
            ],
          ),
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

  Widget _buildObjectivesSection(BuildContext context) {
    final objectives = [
      'Preparar os fiéis leigos para uma inserção e vivência na vida das comunidades eclesiais de base.',
      'Levar cristãos católicos para atuar nas famílias e estruturas sociais, conforme a Pastoral Orgânica de cada Paróquia e Igreja Diocesana de Caratinga-MG.',
      'Fomentar Evangelho nos ambientes e estruturas sociais, pelo testemunho e pela ação pessoal e organizada de seus membros.',
      'Formar líderes para a expansão da PLC em todos os níveis.',
      'Zelar pela fidelidade à sua própria mentalidade, finalidade, método estratégia, contida em seu carisma.',
    ];

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
                    'Finalidades',
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
}
