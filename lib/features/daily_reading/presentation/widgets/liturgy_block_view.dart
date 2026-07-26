import 'package:flutter/material.dart';
import 'package:plc/features/daily_reading/domain/entities/liturgy_body.dart';
import 'package:plc/theme/spacing.dart';

/// Cor das rubricas litúrgicas, que no impresso são vermelhas.
const _rubricColor = Color(0xFFB3261E);

class LiturgyBlockView extends StatelessWidget {
  const LiturgyBlockView({super.key, required this.block});

  final LiturgyBlock block;

  @override
  Widget build(BuildContext context) {
    switch (block.type) {
      case LiturgyBlockType.section:
        return _buildSection(context);
      case LiturgyBlockType.epigraph:
        return _buildEpigraph(context);
      case LiturgyBlockType.refrain:
        return _buildRefrain(context);
      case LiturgyBlockType.verse:
        return _buildVerse(context);
      case LiturgyBlockType.paragraph:
        return _buildParagraph(context);
    }
  }

  Widget _buildSection(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: extraLargeSpacing, bottom: mediumSpacing),
      child: Column(
        children: [
          Text(
            block.text,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: smallSpacing),
          SizedBox(
            width: 48,
            child: Divider(
              thickness: 2,
              color: theme.colorScheme.primary.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEpigraph(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: mediumSpacing),
      child: Text(
        block.text,
        textAlign: TextAlign.right,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color: Colors.grey[600],
              height: 1.4,
            ),
      ),
    );
  }

  Widget _buildRefrain(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: smallSpacing),
      padding: const EdgeInsets.all(smallSpacing),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _richText(
        context,
        base: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildVerse(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: smallSpacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 26,
            child: Text(
              block.verseNumber,
              style: theme.textTheme.labelSmall?.copyWith(
                color: _rubricColor,
                fontSize: 11,
              ),
            ),
          ),
          Expanded(
            child: _richText(
              context,
              base: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParagraph(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: smallSpacing),
      child: _richText(
        context,
        base: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
      ),
    );
  }

  Widget _richText(BuildContext context, {required TextStyle? base}) {
    return Text.rich(
      TextSpan(
        style: base,
        children: block.spans.map((span) {
          return TextSpan(
            text: span.text,
            style: TextStyle(
              fontWeight: span.bold ? FontWeight.bold : null,
              color: span.highlight ? _rubricColor : null,
            ),
          );
        }).toList(),
      ),
    );
  }
}
