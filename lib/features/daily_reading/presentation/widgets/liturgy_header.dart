import 'package:flutter/material.dart';
import 'package:plc/features/daily_reading/domain/entities/daily_reading.dart';
import 'package:plc/features/daily_reading/domain/entities/liturgy_details.dart';
import 'package:plc/theme/spacing.dart';

/// Estola, data, título e observação da liturgia do dia.
///
/// Usado no card da home (`compact`) e no topo da página de detalhe.
class LiturgyHeader extends StatelessWidget {
  const LiturgyHeader({
    super.key,
    required this.reading,
    required this.details,
    this.trailing,
    this.compact = false,
  });

  final DailyReading reading;
  final LiturgyDetails details;
  final Widget? trailing;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = details.title.isNotEmpty ? details.title : reading.title;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LiturgyStole(
          stoleUrl: details.stoleUrl,
          color: reading.color,
          size: compact ? 44 : 56,
        ),
        const SizedBox(width: mediumSpacing),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formatLiturgyDate(reading.date),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.grey[600],
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: (compact
                        ? theme.textTheme.titleMedium
                        : theme.textTheme.headlineSmall)
                    ?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
                maxLines: compact ? 3 : null,
                overflow: compact ? TextOverflow.ellipsis : null,
              ),
              if (details.subtitle.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  details.subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
                  maxLines: compact ? 2 : null,
                  overflow: compact ? TextOverflow.ellipsis : null,
                ),
              ],
              if (details.note.isNotEmpty) ...[
                const SizedBox(height: smallSpacing),
                Text(
                  details.note,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: compact ? 3 : null,
                  overflow: compact ? TextOverflow.ellipsis : null,
                ),
              ],
            ],
          ),
        ),
        if (trailing != null)
          Padding(
            padding: const EdgeInsets.only(left: smallSpacing, top: 4),
            child: trailing,
          ),
      ],
    );
  }
}

/// Imagem da estola litúrgica, com fallback para um círculo na cor do dia.
class LiturgyStole extends StatelessWidget {
  const LiturgyStole({
    super.key,
    required this.stoleUrl,
    required this.color,
    this.size = 44,
  });

  final String? stoleUrl;
  final String color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: liturgyColor(color),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[300]!, width: 2),
      ),
      child: Icon(
        Icons.menu_book,
        size: size / 2,
        color: liturgyColor(color).computeLuminance() > 0.7
            ? Theme.of(context).colorScheme.primary
            : Colors.white,
      ),
    );

    if (stoleUrl == null || stoleUrl!.isEmpty) return fallback;

    return SizedBox(
      width: size,
      height: size,
      child: Image.network(
        stoleUrl!,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => fallback,
      ),
    );
  }
}

/// Referências das leituras do dia, uma por chip.
class LiturgyReadingChips extends StatelessWidget {
  const LiturgyReadingChips({super.key, required this.readings});

  final List<String> readings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: smallSpacing,
      runSpacing: smallSpacing,
      children: readings.map((reading) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: smallSpacing,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.15),
            ),
          ),
          child: Text(
            reading,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }
}

String formatLiturgyDate(DateTime date) {
  const days = [
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira',
    'Sábado',
    'Domingo'
  ];
  const months = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro'
  ];

  return '${days[date.weekday - 1]}, ${date.day} de '
      '${months[date.month - 1]} de ${date.year}';
}

Color liturgyColor(String colorName) {
  switch (colorName.toLowerCase()) {
    case 'roxo':
    case 'purple':
      return Colors.purple;
    case 'branco':
    case 'white':
      return Colors.white;
    case 'vermelho':
    case 'red':
      return Colors.red;
    case 'verde':
    case 'green':
      return Colors.green;
    case 'rosa':
    case 'pink':
      return Colors.pink;
    default:
      return Colors.grey;
  }
}
