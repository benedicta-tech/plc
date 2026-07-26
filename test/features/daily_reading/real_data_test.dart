import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:plc/features/daily_reading/domain/entities/liturgy_body.dart';
import 'package:plc/features/daily_reading/domain/entities/liturgy_details.dart';

/// Roda os parsers contra a planilha real (quase um ano de liturgias).
void main() {
  final file = File('test/examples/exemple-liturgia-diaria.tsv');
  final rows = file
      .readAsLinesSync()
      .skip(1)
      .where((line) => line.trim().isNotEmpty)
      .map((line) => line.split('\t'))
      .toList();

  test('a planilha de exemplo tem dados', () {
    expect(rows, isNotEmpty);
    expect(rows.every((row) => row.length >= 7), isTrue);
  });

  test('todo Detalhe tem título, estola e leituras', () {
    final problems = <String>[];

    for (final row in rows) {
      final details = LiturgyDetails.parse(row[4]);

      if (details.title.isEmpty) problems.add('${row[0]}: sem título');
      if (details.title.length > 120) {
        problems.add('${row[0]}: título suspeito "${details.title}"');
      }
      if (details.stoleUrl == null) problems.add('${row[0]}: sem estola');
      if (details.readings.length < 2) {
        problems.add('${row[0]}: ${details.readings.length} leitura(s)');
      }
      if (details.readings.any((reading) => reading.contains('Leituras'))) {
        problems.add('${row[0]}: rótulo vazou para as leituras');
      }
    }

    expect(problems, isEmpty, reason: problems.take(10).join('\n'));
  });

  test('todo Corpo vira blocos legíveis', () {
    final problems = <String>[];

    for (final row in rows) {
      final blocks = parseLiturgyBody(row[6]);

      if (blocks.length < 5) {
        problems.add('${row[0]}: só ${blocks.length} blocos');
      }
      if (!blocks.any((block) => block.type == LiturgyBlockType.section)) {
        problems.add('${row[0]}: nenhuma seção');
      }
      if (!blocks.any((block) => block.type == LiturgyBlockType.verse)) {
        problems.add('${row[0]}: nenhum versículo');
      }
      if (blocks.any((block) => block.text.trim().isEmpty)) {
        problems.add('${row[0]}: bloco vazio');
      }
      if (blocks.any((block) => block.text.contains(RegExp(r'<[a-zA-Z/]')))) {
        problems.add('${row[0]}: sobrou tag html');
      }
      if (blocks.any((block) => block.text.contains('display:'))) {
        problems.add('${row[0]}: sobrou css');
      }
    }

    expect(problems, isEmpty, reason: problems.take(10).join('\n'));
  });

  test('os títulos de seção são curtos', () {
    // Título longo significa que o texto da leitura (ou uma rubrica pastoral)
    // vazou para dentro do cabeçalho.
    final problems = <String>{};

    for (final row in rows) {
      for (final block in parseLiturgyBody(row[6])) {
        if (block.type != LiturgyBlockType.section) continue;
        if (block.text.length > 60) problems.add('${row[0]}: "${block.text}"');
      }
    }

    expect(problems, isEmpty, reason: problems.take(10).join('\n'));
  });

  test('toda liturgia anuncia a primeira leitura e o evangelho', () {
    final problems = <String>[];

    for (final row in rows) {
      final sections = parseLiturgyBody(row[6])
          .where((block) => block.type == LiturgyBlockType.section)
          .map((block) => block.text.toUpperCase())
          .toList();

      if (!sections.any((title) => title.contains('LEITURA'))) {
        problems.add('${row[0]}: sem primeira leitura');
      }
      if (!sections.any((title) => title.contains('EVANGELHO'))) {
        problems.add('${row[0]}: sem evangelho');
      }
    }

    expect(problems, isEmpty, reason: problems.take(10).join('\n'));
  });
}
