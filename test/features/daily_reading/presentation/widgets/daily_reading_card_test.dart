import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plc/features/daily_reading/presentation/widgets/daily_reading_card.dart';

import '../../daily_reading_fixtures.dart';

void main() {
  testWidgets('mostra a leitura de hoje, não a primeira da lista',
      (tester) async {
    final today = DateTime.now();

    await pumpWithBloc(
      tester,
      [
        buildReading(
          date: today.subtract(const Duration(days: 1)),
          details: '<div><div><b>Leitura de ontem</b></div></div>',
        ),
        buildReading(
          date: DateTime(today.year, today.month, today.day, 10),
          details: sundayDetailsHtml,
        ),
      ],
      const Scaffold(body: DailyReadingCard()),
    );

    expect(find.text('17º Domingo do Tempo Comum, Ano A'), findsOneWidget);
    expect(find.text('Leitura de ontem'), findsNothing);
  });

  testWidgets('renderiza data, observação e leituras do html', (tester) async {
    await pumpWithBloc(
      tester,
      [buildReading(date: DateTime(2026, 7, 26), details: sundayDetailsHtml)],
      const Scaffold(body: DailyReadingCard()),
    );

    expect(find.text('Domingo, 26 de Julho de 2026'), findsOneWidget);
    expect(
      find.text('Hoje, omite-se a Memória de Santos Joaquim e Ana'),
      findsOneWidget,
    );
    expect(find.text('Leituras'), findsOneWidget);
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
      const Scaffold(body: DailyReadingCard()),
    );

    expect(find.text('São Bento, abade, Memória'), findsOneWidget);
    expect(find.text('14ª Semana do Tempo Comum'), findsOneWidget);
  });

  testWidgets('usa o tempo litúrgico da planilha quando o html vem vazio',
      (tester) async {
    await pumpWithBloc(
      tester,
      [buildReading(date: DateTime.now(), title: 'Tempo Comum')],
      const Scaffold(body: DailyReadingCard()),
    );

    expect(find.text('Tempo Comum'), findsOneWidget);
    expect(find.text('Leituras'), findsNothing);
  });

  testWidgets('não renderiza nada quando não há leituras', (tester) async {
    await pumpWithBloc(tester, [], const Scaffold(body: DailyReadingCard()));

    expect(find.byType(Card), findsNothing);
  });
}
