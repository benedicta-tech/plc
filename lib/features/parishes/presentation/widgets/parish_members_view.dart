import 'package:flutter/material.dart';
import 'package:plc/features/parishes/domain/entities/member.dart';
import 'package:plc/theme/spacing.dart';

/// Monta as seções de pessoas da paróquia a partir da aba de membros.
/// Cada seção some quando não tem ninguém, para a página não virar uma lista
/// de títulos em branco.
class ParishMembersView extends StatelessWidget {
  static const masculine = 'Masculino';
  static const feminine = 'Feminino';

  /// Convenção do PLC: verde no ramo masculino, rosa no feminino.
  static final masculineColor = Colors.green[700]!;
  static final feminineColor = Colors.pink[400]!;

  final List<Member> members;

  const ParishMembersView({super.key, required this.members});

  @override
  Widget build(BuildContext context) {
    final priests = members.where((m) => m.isPriest && !m.isFounding).toList();
    final preachers = members.where((m) => m.isPreacher).toList();
    final current =
        members.where((m) => m.isCoordination && !m.isFounding).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // pároco não repete o cargo: a seção já diz qual é
        _section(context, 'Pároco', priests, showRole: false),
        _section(
          context,
          'Coordenação masculina',
          current.where((m) => m.branch == masculine).toList(),
          color: masculineColor,
        ),
        _section(
          context,
          'Coordenação feminina',
          current.where((m) => m.branch == feminine).toList(),
          color: feminineColor,
        ),
        _section(context, 'Pregadores', preachers, showLectures: true),
      ],
    );
  }

  Widget _section(
    BuildContext context,
    String title,
    List<Member> people, {
    bool showRole = true,
    bool showLectures = false,
    Color? color,
  }) {
    if (people.isEmpty) return const SizedBox.shrink();
    final cor = color ?? Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: defaultSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: cor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: smallSpacing),
          ...people.map((m) => _MemberTile(
                member: m,
                color: cor,
                showRole: showRole,
                showLectures: showLectures,
              )),
        ],
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  final Member member;
  final Color color;
  final bool showRole;
  final bool showLectures;

  const _MemberTile({
    required this.member,
    required this.color,
    this.showRole = true,
    this.showLectures = false,
  });

  /// Na seção de pregadores o que interessa é qual pregação, não o cargo.
  String? get _subtitle {
    if (showLectures && member.lectures.isNotEmpty) {
      return member.lectures.join(', ');
    }
    return showRole ? member.roleLabel : null;
  }

  @override
  Widget build(BuildContext context) {
    final subtitle = _subtitle;

    return Padding(
      padding: const EdgeInsets.only(bottom: smallSpacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.person_outline, size: 20, color: color),
          const SizedBox(width: mediumSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey[600]),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
