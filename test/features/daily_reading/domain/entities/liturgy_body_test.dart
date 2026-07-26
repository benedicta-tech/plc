import 'package:flutter_test/flutter_test.dart';
import 'package:plc/features/daily_reading/domain/entities/liturgy_body.dart';

/// Trecho real do campo `Corpo`, com todas as estruturas que a CNBB usa.
const _bodyHtml = '''
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"><font color="red"><center>PRIMEIRA LEITURA</center></font><p align="right"><i>Eis que uma virgem conceberá.<br> </i></p>Leitura do Livro do Profeta Isaías <font color="#ff6666">7,10-14</font><br> <br> <div><div style="display: flex;flex-direction:row;align-items:flex-start"><div style="text-align: left; min-width: 30px; font-size: 12px; color: #FF0000"><br></div><div><div style="flex: 1"><div>Naqueles dias,</div></div></div></div></div><div><div style="display: flex;flex-direction:row;align-items:flex-start"><div style="text-align: left; min-width: 30px; font-size: 12px; color: #FF0000">10</div><div><div style="flex: 1"><div>o Senhor falou com Acaz, dizendo:</div></div></div></div></div><span class="refrao_salmo"><font color="#ff0000">R.</font> Senhor, eu cantarei eternamente o vosso amor!</span><div id="15" style="display: none;"><h3 class="title-leitura">2ª Leitura - Rm 1,1-7</h3></div><div class="div-secao-liturgia"><center><font color="red">EVANGELHO</font></center><img src="https://liturgiadiaria.edicoescnbb.com.br/pics/cruzevangelho.png" width="32"></div><div><div style="display: flex;flex-direction:row;align-items:flex-start"><div style="text-align: left; min-width: 30px; font-size: 12px; color: #FF0000">24</div><div><div style="flex: 1"><div>Quando acordou,<br>  José fez conforme o anjo do Senhor havia mandado.<br>  <span class="tabulacao negrito">Palavra da Salvação.</span></div></div></div></div></div>
''';

void main() {
  group('parseLiturgyBody', () {
    final blocks = parseLiturgyBody(_bodyHtml);

    test('reconhece os títulos de seção', () {
      final sections = blocks
          .where((block) => block.type == LiturgyBlockType.section)
          .map((block) => block.text)
          .toList();

      expect(sections, ['PRIMEIRA LEITURA', 'EVANGELHO']);
    });

    test('reconhece a epígrafe em itálico', () {
      final epigraph = blocks.firstWhere(
        (block) => block.type == LiturgyBlockType.epigraph,
      );

      expect(epigraph.text, 'Eis que uma virgem conceberá.');
    });

    test('mantém a introdução da leitura com a referência', () {
      expect(
        blocks.any((block) =>
            block.type == LiturgyBlockType.paragraph &&
            block.text == 'Leitura do Livro do Profeta Isaías 7,10-14'),
        isTrue,
      );
    });

    test('separa número e texto de cada versículo', () {
      final verses = blocks
          .where((block) => block.type == LiturgyBlockType.verse)
          .toList();

      expect(verses, hasLength(3));
      expect(verses[0].verseNumber, isEmpty);
      expect(verses[0].text, 'Naqueles dias,');
      expect(verses[1].verseNumber, '10');
      expect(verses[1].text, 'o Senhor falou com Acaz, dizendo:');
    });

    test('preserva as quebras de linha do versículo', () {
      final verse = blocks.lastWhere(
        (block) => block.type == LiturgyBlockType.verse,
      );

      expect(
        verse.text,
        'Quando acordou,\n'
        'José fez conforme o anjo do Senhor havia mandado.\n'
        'Palavra da Salvação.',
      );
    });

    test('marca o negrito de "Palavra da Salvação"', () {
      final verse = blocks.lastWhere(
        (block) => block.type == LiturgyBlockType.verse,
      );
      final bold = verse.spans.where((span) => span.bold).map((s) => s.text);

      expect(bold, contains('Palavra da Salvação.'));
    });

    test('reconhece o refrão do salmo', () {
      final refrain = blocks.firstWhere(
        (block) => block.type == LiturgyBlockType.refrain,
      );

      expect(refrain.text, 'R. Senhor, eu cantarei eternamente o vosso amor!');
      expect(refrain.spans.first.highlight, isTrue);
    });

    test('ignora blocos escondidos com display none', () {
      expect(
        blocks.any((block) => block.text.contains('2ª Leitura - Rm 1,1-7')),
        isFalse,
      );
    });

    test('não gera blocos vazios', () {
      expect(blocks.any((block) => block.text.trim().isEmpty), isFalse);
    });

    test('sequências de <br> viram no máximo uma linha em branco', () {
      final blocks = parseLiturgyBody('<div>Missa<br><br><br><br>do dia</div>');

      expect(blocks.single.text, 'Missa\n\ndo dia');
    });

    test('devolve lista vazia para conteúdo vazio', () {
      expect(parseLiturgyBody(''), isEmpty);
      expect(parseLiturgyBody('<div><br></div>'), isEmpty);
    });
  });
}
