import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;

/// Conteúdo do campo `Detalhe`, que vem como HTML da CNBB.
///
/// O bloco de texto tem sempre a data, o título em negrito e, opcionalmente,
/// um tempo litúrgico secundário (memórias e festas) ou uma observação em
/// itálico.
class LiturgyDetails {
  final String title;
  final String subtitle;
  final String note;
  final List<String> readings;
  final String? stoleUrl;

  const LiturgyDetails({
    required this.title,
    required this.subtitle,
    required this.note,
    required this.readings,
    this.stoleUrl,
  });

  factory LiturgyDetails.parse(String rawHtml) {
    final body = html_parser.parse(rawHtml).body;
    if (body == null) {
      return const LiturgyDetails(
        title: '',
        subtitle: '',
        note: '',
        readings: [],
      );
    }

    final titleElement = body.querySelector('b')?.parent;

    var subtitle = '';
    var note = '';
    for (final sibling in _siblingsAfter(titleElement)) {
      final text = _clean(sibling.text);
      if (text.isEmpty) continue;

      if (sibling.querySelector('i') != null) {
        if (note.isEmpty) note = text;
      } else if (subtitle.isEmpty) {
        subtitle = text;
      }
    }

    return LiturgyDetails(
      title: _clean(titleElement?.text ?? body.text),
      subtitle: subtitle,
      note: note,
      readings: _parseReadings(body),
      stoleUrl: body.querySelector('img')?.attributes['src'],
    );
  }

  static Iterable<Element> _siblingsAfter(Element? element) {
    final siblings = element?.parent?.children;
    if (siblings == null) return const [];
    return siblings.skip(siblings.indexOf(element!) + 1);
  }

  static List<String> _parseReadings(Element body) {
    final label = body.querySelectorAll('div').where((element) {
      return element.children.isEmpty &&
          _clean(element.text).toLowerCase().startsWith('leituras');
    }).firstOrNull;

    return label?.parent?.children
            .where((element) => element != label)
            .map((element) => _clean(element.text))
            .where((text) => text.isNotEmpty)
            .toList() ??
        const [];
  }

  static String _clean(String text) =>
      text.replaceAll(RegExp(r'\s+'), ' ').trim();
}
