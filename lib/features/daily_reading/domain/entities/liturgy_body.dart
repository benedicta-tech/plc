import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;

enum LiturgyBlockType { section, epigraph, refrain, verse, paragraph }

class LiturgySpan {
  final String text;
  final bool bold;
  final bool highlight;

  const LiturgySpan(this.text, {this.bold = false, this.highlight = false});
}

class LiturgyBlock {
  final LiturgyBlockType type;
  final String verseNumber;
  final List<LiturgySpan> spans;

  const LiturgyBlock(this.type, this.spans, {this.verseNumber = ''});

  String get text => spans.map((span) => span.text).join();
}

/// Converte o campo `Corpo` (HTML da CNBB) em blocos prontos para renderizar:
/// títulos de seção, epígrafes, refrões do salmo, versículos numerados e
/// parágrafos comuns.
List<LiturgyBlock> parseLiturgyBody(String rawHtml) {
  final body = html_parser.parse(rawHtml).body;
  if (body == null) return const [];

  final builder = _BlockBuilder();
  builder.visitChildren(body, const _InlineStyle());
  return builder.flush(LiturgyBlockType.paragraph).blocks;
}

class _InlineStyle {
  final bool bold;
  final bool highlight;

  const _InlineStyle({this.bold = false, this.highlight = false});

  _InlineStyle merge({bool? bold, bool? highlight}) => _InlineStyle(
        bold: bold ?? this.bold,
        highlight: highlight ?? this.highlight,
      );
}

class _BlockBuilder {
  final List<LiturgyBlock> blocks = [];
  final List<LiturgySpan> _pending = [];

  void visitChildren(Element element, _InlineStyle style) {
    for (final node in element.nodes) {
      if (node is Text) {
        _addText(node.text, style);
      } else if (node is Element) {
        _visitElement(node, style);
      }
    }
  }

  void _visitElement(Element element, _InlineStyle style) {
    if (_isHidden(element)) return;

    switch (element.localName) {
      case 'meta':
      case 'head':
      case 'title':
      case 'style':
      case 'script':
      case 'img':
        return;
      case 'br':
        _addText('\n', style);
        return;
      case 'center':
        _emit(element, LiturgyBlockType.section, style);
        return;
      case 'sup':
        visitChildren(element, style);
        return;
      case 'p':
        if (element.attributes['align'] == 'right') {
          _emit(element, LiturgyBlockType.epigraph, style);
          return;
        }
        _addText('\n', style);
        visitChildren(element, style);
        _addText('\n', style);
        return;
      case 'b':
      case 'strong':
        visitChildren(element, style.merge(bold: true));
        return;
      case 'i':
      case 'em':
        visitChildren(element, style);
        return;
      case 'font':
        visitChildren(
          element,
          style.merge(highlight: _isHighlight(element.attributes['color'])),
        );
        return;
    }

    if (element.classes.contains('refrao_salmo')) {
      _emit(element, LiturgyBlockType.refrain, style);
      return;
    }

    final verse = _asVerse(element);
    if (verse != null) {
      flush(LiturgyBlockType.paragraph);
      visitChildren(verse.value, style);
      final spans = _takePending();
      if (spans.isNotEmpty) {
        blocks.add(
          LiturgyBlock(
            LiturgyBlockType.verse,
            spans,
            verseNumber: verse.key,
          ),
        );
      }
      return;
    }

    if (element.localName == 'div') {
      visitChildren(element, style.merge(bold: _isBoldClass(element)));
      _addText('\n', style);
      return;
    }

    visitChildren(element, style.merge(bold: _isBoldClass(element)));
  }

  /// Versículo: uma coluna estreita com o número e outra com o texto.
  MapEntry<String, Element>? _asVerse(Element element) {
    if (element.children.length != 2) return null;
    final marker = element.children.first;
    if (!(marker.attributes['style'] ?? '').contains('min-width')) return null;

    return MapEntry(_squash(marker.text), element.children.last);
  }

  void _emit(Element element, LiturgyBlockType type, _InlineStyle style) {
    flush(LiturgyBlockType.paragraph);
    visitChildren(element, style);
    final spans = _takePending();
    if (spans.isEmpty) return;

    // ponytail: rubricas pastorais também vêm centralizadas; só o texto curto
    // é cabeçalho de verdade.
    final length = spans.fold(0, (sum, span) => sum + span.text.length);
    final isHeading = type != LiturgyBlockType.section || length <= 60;

    blocks.add(
      LiturgyBlock(isHeading ? type : LiturgyBlockType.paragraph, spans),
    );
  }

  void _addText(String text, _InlineStyle style) {
    final normalized = text.replaceAll(RegExp(r'[ \t\r ]+'), ' ');
    if (normalized.isEmpty) return;
    _pending.add(
      LiturgySpan(normalized, bold: style.bold, highlight: style.highlight),
    );
  }

  _BlockBuilder flush(LiturgyBlockType type) {
    final spans = _takePending();
    if (spans.isNotEmpty) blocks.add(LiturgyBlock(type, spans));
    return this;
  }

  /// Junta os spans acumulados: espaços em volta das quebras somem, assim como
  /// as linhas em branco nas bordas do bloco.
  List<LiturgySpan> _takePending() {
    final source = [..._pending];
    _pending.clear();

    final spans = <LiturgySpan>[];
    var atStart = true;
    var afterBreak = false;

    for (final span in source) {
      var text = span.text.replaceAll(RegExp(r' *\n[ \n]*'), '\n');
      if (atStart) {
        text = text.replaceFirst(RegExp(r'^[ \n]+'), '');
      } else if (afterBreak) {
        text = text.replaceFirst(RegExp(r'^ +'), '');
      }
      if (text.isEmpty) continue;

      atStart = false;
      afterBreak = text.endsWith('\n');
      spans.add(
        LiturgySpan(text, bold: span.bold, highlight: span.highlight),
      );
    }

    while (spans.isNotEmpty) {
      final last = spans.removeLast();
      final trimmed = last.text.replaceFirst(RegExp(r'\s+$'), '');
      if (trimmed.isNotEmpty) {
        spans.add(
          LiturgySpan(trimmed, bold: last.bold, highlight: last.highlight),
        );
        break;
      }
    }

    return _capBlankLines(spans);
  }

  /// Sequências de `<br>` viram no máximo uma linha em branco.
  List<LiturgySpan> _capBlankLines(List<LiturgySpan> spans) {
    final capped = <LiturgySpan>[];
    var breaks = 0;

    for (final span in spans) {
      if (span.text.trim().isEmpty && span.text.contains('\n')) {
        breaks++;
        if (breaks > 2) continue;
      } else {
        breaks = span.text.endsWith('\n') ? 1 : 0;
      }
      capped.add(span);
    }

    return capped;
  }
}

bool _isHidden(Element element) =>
    (element.attributes['style'] ?? '').replaceAll(' ', '').contains(
          'display:none',
        );

bool _isBoldClass(Element element) =>
    element.classes.contains('negrito') ? true : false;

bool _isHighlight(String? color) {
  if (color == null) return false;
  final value = color.trim().toLowerCase();
  return value == 'red' ||
      value == 'tomato' ||
      value.startsWith('#ff') ||
      value.startsWith('#fc');
}

String _squash(String text) => text.replaceAll(RegExp(r'\s+'), ' ').trim();
