import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plc/core/features/core_features.dart';
import 'package:plc/features/daily_reading/domain/entities/daily_reading.dart';
import 'package:plc/features/daily_reading/domain/entities/liturgy_details.dart';
import 'package:plc/features/daily_reading/presentation/pages/daily_reading_page.dart';
import 'package:plc/features/daily_reading/presentation/widgets/liturgy_header.dart';
import 'package:plc/theme/spacing.dart';

class DailyReadingCard extends StatefulWidget {
  const DailyReadingCard({super.key});

  @override
  State<DailyReadingCard> createState() => _DailyReadingCardState();
}

class _DailyReadingCardState extends State<DailyReadingCard> {
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
    return BlocBuilder<GenericListBloc<DailyReading, String>,
        GenericListState<DailyReading>>(
      builder: (context, state) {
        if (state is ListLoading<DailyReading>) {
          return _cardShell(
            context,
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
        }

        if (state is ListLoaded<DailyReading, String>) {
          final reading = _getTodayReading(state.items);
          if (reading == null) return const SizedBox.shrink();

          return _cardShell(
            context,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DailyReadingPage()),
            ),
            child: _buildContent(context, reading),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _cardShell(BuildContext context,
      {required Widget child, VoidCallback? onTap}) {
    final primary = Theme.of(context).colorScheme.primary;

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primary.withValues(alpha: 0.1),
              primary.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(mediumSpacing),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, DailyReading reading) {
    final theme = Theme.of(context);
    final details = LiturgyDetails.parse(reading.details);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LiturgyHeader(
          reading: reading,
          details: details,
          compact: true,
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: theme.colorScheme.primary,
            size: 16,
          ),
        ),
        if (details.readings.isNotEmpty) ...[
          const SizedBox(height: mediumSpacing),
          Divider(
            height: 1,
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
          ),
          const SizedBox(height: mediumSpacing),
          Text(
            'Leituras',
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: smallSpacing),
          LiturgyReadingChips(readings: details.readings),
        ],
      ],
    );
  }
}
