import 'package:flutter_test/flutter_test.dart';
import 'package:plc/features/daily_reading/domain/entities/liturgy_details.dart';

/// Domingo com observação em itálico e sem tempo litúrgico secundário.
const _sundayHtml = '''
<div><div style="display: flex; flex-direction: flex-start; align-items: center"><div style="padding: 0 10px 10px 0"><img src="https://liturgiadiaria.edicoescnbb.com.br/estolas/verde.png" style="width: 30px;"></div><div style="flex: 1"><div style="font-size: 12px; font-weight: lighter; color: #AFAFAF">Domingo, 26 de Julho de 2026</div><div style="font-size: 26px;"><b>17º Domingo  do Tempo Comum</b>, Ano A</div><div style="font-size: 12px; color: #8a8a8a; font-weight: lighter"><i>Hoje, omite-se a Memória de Santos Joaquim e Ana, pais da Bem-aventurada Virgem Maria</i></b></div></div></div><div style="padding: 30px 35px"><div style="color: #6a6a6a;">Leituras: </div><div>1Rs 3,5.7-12</div><div> Sl 118(119),57.72.76-77.127-128.129-130 (R. 97a)</div><div> Rm 8,28-30</div><div> Mt 13,44-52  ou mais breve 13,44-46</div></div></div>
''';

/// Memória de santo: título é o santo e o tempo litúrgico vira subtítulo.
const _saintHtml = '''
<div><div style="display: flex; flex-direction: flex-start; align-items: center"><div style="padding: 0 10px 10px 0"><img src="https://liturgiadiaria.edicoescnbb.com.br/estolas/branco.png" style="width: 30px;"></div><div style="flex: 1"><div style="font-size: 12px; font-weight: lighter; color: #AFAFAF">Sábado, 11 de Julho de 2026</div><div style="font-size: 26px;"><b>São Bento, abade</b>, Memória</div><div style="font-size: 20px;">14ª Semana  do Tempo Comum</div></div></div><div style="padding: 30px 35px"><div style="color: #6a6a6a;">Leituras: </div><div>Is 6,1-8</div><div> Sl 92(93),1ab.1c-2.5 (R. 1a)</div><div> Mt 10,24-33</div></div></div>
''';

/// Feria: o div do subtítulo existe mas vem vazio.
const _ferialHtml = '''
<div><div style="display: flex; flex-direction: flex-start; align-items: center"><div style="padding: 0 10px 10px 0"><img src="https://liturgiadiaria.edicoescnbb.com.br/estolas/verde.png" style="width: 30px;"></div><div style="flex: 1"><div style="font-size: 12px; font-weight: lighter; color: #AFAFAF">Quarta-feira, 8 de Julho de 2026</div><div style="font-size: 26px;"><b>14ª Semana  do Tempo Comum</b>, Ano Par (II)</div><div style="font-size: 20px;"></div></div></div><div style="padding: 30px 35px"><div style="color: #6a6a6a;">Leituras: </div><div>Os 10,1-3.7-8.12</div><div> Sl 104(105),2-3.4-5.6-7 (R. 4b)</div><div> Mt 10,1-7</div></div></div>
''';

void main() {
  group('LiturgyDetails.parse', () {
    test('extrai título completo incluindo o ano litúrgico', () {
      final details = LiturgyDetails.parse(_sundayHtml);

      expect(details.title, '17º Domingo do Tempo Comum, Ano A');
    });

    test('extrai a observação em itálico', () {
      final details = LiturgyDetails.parse(_sundayHtml);

      expect(
        details.note,
        'Hoje, omite-se a Memória de Santos Joaquim e Ana, '
        'pais da Bem-aventurada Virgem Maria',
      );
      expect(details.subtitle, isEmpty);
    });

    test('extrai as leituras sem o rótulo "Leituras:"', () {
      final details = LiturgyDetails.parse(_sundayHtml);

      expect(details.readings, [
        '1Rs 3,5.7-12',
        'Sl 118(119),57.72.76-77.127-128.129-130 (R. 97a)',
        'Rm 8,28-30',
        'Mt 13,44-52 ou mais breve 13,44-46',
      ]);
    });

    test('extrai a url da estola', () {
      final details = LiturgyDetails.parse(_sundayHtml);

      expect(
        details.stoleUrl,
        'https://liturgiadiaria.edicoescnbb.com.br/estolas/verde.png',
      );
    });

    test('memória de santo traz o tempo litúrgico como subtítulo', () {
      final details = LiturgyDetails.parse(_saintHtml);

      expect(details.title, 'São Bento, abade, Memória');
      expect(details.subtitle, '14ª Semana do Tempo Comum');
      expect(details.note, isEmpty);
      expect(
        details.stoleUrl,
        'https://liturgiadiaria.edicoescnbb.com.br/estolas/branco.png',
      );
    });

    test('ignora o div de subtítulo quando vem vazio', () {
      final details = LiturgyDetails.parse(_ferialHtml);

      expect(details.title, '14ª Semana do Tempo Comum, Ano Par (II)');
      expect(details.subtitle, isEmpty);
      expect(details.note, isEmpty);
      expect(details.readings, hasLength(3));
    });

    test('devolve campos vazios para html vazio', () {
      final details = LiturgyDetails.parse('');

      expect(details.title, isEmpty);
      expect(details.subtitle, isEmpty);
      expect(details.note, isEmpty);
      expect(details.readings, isEmpty);
      expect(details.stoleUrl, isNull);
    });

    test('usa o texto puro como título quando não há marcação', () {
      final details = LiturgyDetails.parse('17º Domingo do Tempo Comum');

      expect(details.title, '17º Domingo do Tempo Comum');
      expect(details.readings, isEmpty);
    });

    test('não quebra quando faltam observação, estola e leituras', () {
      final details = LiturgyDetails.parse(
        '<div><div><div><b>Santa Maria</b>, Ano B</div></div></div>',
      );

      expect(details.title, 'Santa Maria, Ano B');
      expect(details.subtitle, isEmpty);
      expect(details.note, isEmpty);
      expect(details.readings, isEmpty);
      expect(details.stoleUrl, isNull);
    });

    test('converte entidades html e normaliza espaços', () {
      final details = LiturgyDetails.parse(
        '<div><div><b>Ss.&nbsp;Joaquim   e Ana</b></div></div>',
      );

      expect(details.title, 'Ss. Joaquim e Ana');
    });

    test('ignora rótulo de leituras quando não há itens', () {
      final details = LiturgyDetails.parse(
        '<div><div><b>Feria</b></div><div><div>Leituras: </div></div></div>',
      );

      expect(details.readings, isEmpty);
    });
  });
}
