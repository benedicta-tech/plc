import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plc/core/features/core_features.dart';
import 'package:plc/features/daily_reading/domain/entities/daily_reading.dart';
import 'package:plc/features/daily_reading/domain/entities/liturgy_body.dart';
import 'package:plc/features/daily_reading/domain/entities/liturgy_details.dart';
import 'package:plc/features/daily_reading/presentation/widgets/liturgy_block_view.dart';
import 'package:plc/features/daily_reading/presentation/widgets/liturgy_header.dart';
import 'package:plc/theme/spacing.dart';

class DailyReadingPage extends StatefulWidget {
  const DailyReadingPage({super.key});

  @override
  State<DailyReadingPage> createState() => _DailyReadingPageState();
}

class _DailyReadingPageState extends State<DailyReadingPage> {
  @override
  void initState() {
    super.initState();
    context.read<GenericListBloc<DailyReading, String>>().add(LoadItems());
  }

  DailyReading? _getTodayReading(List<DailyReading> readings) {
    if (readings.isEmpty) return null;

    final today = DateTime.now();
    return readings.firstWhere(
      (reading) => DateUtils.isSameDay(reading.date, today),
      orElse: () => readings.first,
    );
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
          'Liturgia Diária',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: BlocBuilder<GenericListBloc<DailyReading, String>,
          GenericListState<DailyReading>>(
        builder: (context, state) {
          if (state is ListLoading<DailyReading>) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          } else if (state is ListLoaded<DailyReading, String>) {
            final todayReading = _getTodayReading(state.items);

            if (todayReading == null) {
              return _buildEmptyState(context);
            }

            return _buildReadingContent(context, todayReading);
          } else if (state is ListError<DailyReading>) {
            return _buildErrorState(context, state.message);
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildReadingContent(BuildContext context, DailyReading reading) {
    final details = LiturgyDetails.parse(reading.details);
    final blocks = parseLiturgyBody(reading.body);

    return ListView.builder(
      padding: const EdgeInsets.all(mediumSpacing),
      itemCount: blocks.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return _buildHeader(context, reading, details);
        return LiturgyBlockView(block: blocks[index - 1]);
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    DailyReading reading,
    LiturgyDetails details,
  ) {
    return Container(
      padding: const EdgeInsets.all(mediumSpacing),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LiturgyHeader(reading: reading, details: details),
          if (details.readings.isNotEmpty) ...[
            const SizedBox(height: mediumSpacing),
            LiturgyReadingChips(readings: details.readings),
          ],
          if (reading.color.isNotEmpty) ...[
            const SizedBox(height: mediumSpacing),
            Text(
              'Cor Litúrgica: ${_capitalizeFirst(reading.color)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[700],
                  ),
            ),
          ],
        ],
      ),
    );
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
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
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.book_outlined,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Nenhuma leitura encontrada',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Não encontramos a liturgia para hoje. Por favor, tente novamente mais tarde.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey[600]),
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
              'Erro ao carregar liturgia',
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
                context.read<GenericListBloc<DailyReading, String>>().add(
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
