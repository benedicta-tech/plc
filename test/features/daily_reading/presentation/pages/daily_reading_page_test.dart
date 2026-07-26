import 'package:flutter_test/flutter_test.dart';
import 'package:plc/features/daily_reading/presentation/pages/daily_reading_page.dart';

import '../../daily_reading_fixtures.dart';

void main() {
  testWidgets('mostra data, título, observação e leituras do html',
      (tester) async {
    await pumpWithBloc(
      tester,
      [
        buildReading(
          date: DateTime(2026, 7, 26),
          details: sundayDetailsHtml,
        ),
      ],
      const DailyReadingPage(),
    );

    expect(find.text('Domingo, 26 de Julho de 2026'), findsOneWidget);
    expect(find.text('17º Domingo do Tempo Comum, Ano A'), findsOneWidget);
    expect(
      find.text('Hoje, omite-se a Memória de Santos Joaquim e Ana'),
      findsOneWidget,
    );
    expect(find.text('1Rs 3,5.7-12'), findsOneWidget);
    expect(find.text('Rm 8,28-30'), findsOneWidget);
    expect(find.textContaining('Leituras:'), findsNothing);
  });

  testWidgets('mostra o tempo litúrgico secundário das memórias',
      (tester) async {
    await pumpWithBloc(
      tester,
      [
        buildReading(
          date: DateTime(2026, 7, 11),
          color: 'branco',
          details: saintDetailsHtml,
        ),
      ],
      const DailyReadingPage(),
    );

    expect(find.text('São Bento, abade, Memória'), findsOneWidget);
    expect(find.text('14ª Semana do Tempo Comum'), findsOneWidget);
    expect(find.text('Cor Litúrgica: Branco'), findsOneWidget);
  });

  testWidgets('renderiza o corpo em seções, epígrafe e versículos numerados',
      (tester) async {
    await pumpWithBloc(
      tester,
      [
        buildReading(
          date: DateTime(2026, 7, 26),
          details: sundayDetailsHtml,
          readings: '<div>Leituras:</div><div>1Rs 3,5.7-12</div>',
          body: liturgyBodyHtml,
        ),
      ],
      const DailyReadingPage(),
    );

    expect(find.text('PRIMEIRA LEITURA'), findsOneWidget);
    expect(find.text('Eis que uma virgem conceberá.'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
    expect(
      find.textContaining('o Senhor falou com Acaz, dizendo:',
          findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining('Senhor, eu cantarei eternamente o vosso amor!',
          findRichText: true),
      findsOneWidget,
    );
    // O campo Leituras repete o que já aparece nos chips do cabeçalho.
    expect(find.text('1Rs 3,5.7-12'), findsOneWidget);
  });

  testWidgets('usa o tempo litúrgico da planilha quando o html vem vazio',
      (tester) async {
    await pumpWithBloc(
      tester,
      [buildReading(date: DateTime(2026, 7, 26), title: 'Tempo Comum')],
      const DailyReadingPage(),
    );

    expect(find.text('Tempo Comum'), findsOneWidget);
  });

  testWidgets('mostra estado vazio quando não há leituras', (tester) async {
    await pumpWithBloc(tester, [], const DailyReadingPage());

    expect(find.text('Nenhuma leitura encontrada'), findsOneWidget);
  });
}
