import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plc/core/features/core_features.dart';
import 'package:plc/features/daily_reading/domain/entities/daily_reading.dart';

/// Domingo com observação em itálico e sem tempo litúrgico secundário.
const sundayDetailsHtml = '''
<div><div style="display: flex"><div><img src="https://liturgiadiaria.edicoescnbb.com.br/estolas/verde.png" style="width: 30px;"></div><div><div style="font-size: 12px">Domingo, 26 de Julho de 2026</div><div style="font-size: 26px;"><b>17º Domingo  do Tempo Comum</b>, Ano A</div><div><i>Hoje, omite-se a Memória de Santos Joaquim e Ana</i></div></div></div><div><div>Leituras: </div><div>1Rs 3,5.7-12</div><div> Rm 8,28-30</div></div></div>
''';

/// Memória de santo: o tempo litúrgico vira subtítulo.
const saintDetailsHtml = '''
<div><div style="display: flex"><div><img src="https://liturgiadiaria.edicoescnbb.com.br/estolas/branco.png" style="width: 30px;"></div><div><div style="font-size: 12px">Sábado, 11 de Julho de 2026</div><div style="font-size: 26px;"><b>São Bento, abade</b>, Memória</div><div style="font-size: 20px;">14ª Semana  do Tempo Comum</div></div></div><div><div>Leituras: </div><div>Is 6,1-8</div><div> Mt 10,24-33</div></div></div>
''';

/// Trecho real do campo `Corpo`, com todas as estruturas que a CNBB usa.
const liturgyBodyHtml = '''
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"><font color="red"><center>PRIMEIRA LEITURA</center></font><p align="right"><i>Eis que uma virgem conceberá.<br> </i></p>Leitura do Livro do Profeta Isaías <font color="#ff6666">7,10-14</font><br> <br> <div><div style="display: flex;flex-direction:row;align-items:flex-start"><div style="text-align: left; min-width: 30px; font-size: 12px; color: #FF0000"><br></div><div><div style="flex: 1"><div>Naqueles dias,</div></div></div></div></div><div><div style="display: flex;flex-direction:row;align-items:flex-start"><div style="text-align: left; min-width: 30px; font-size: 12px; color: #FF0000">10</div><div><div style="flex: 1"><div>o Senhor falou com Acaz, dizendo:</div></div></div></div></div><span class="refrao_salmo"><font color="#ff0000">R.</font> Senhor, eu cantarei eternamente o vosso amor!</span><div id="15" style="display: none;"><h3 class="title-leitura">2ª Leitura - Rm 1,1-7</h3></div><div class="div-secao-liturgia"><center><font color="red">EVANGELHO</font></center><img src="https://liturgiadiaria.edicoescnbb.com.br/pics/cruzevangelho.png" width="32"></div><div><div style="display: flex;flex-direction:row;align-items:flex-start"><div style="text-align: left; min-width: 30px; font-size: 12px; color: #FF0000">24</div><div><div style="flex: 1"><div>Quando acordou,<br>  José fez conforme o anjo do Senhor havia mandado.<br>  <span class="tabulacao negrito">Palavra da Salvação.</span></div></div></div></div></div>
''';

class FakeDailyReadingRepository implements GenericRepository<DailyReading> {
  FakeDailyReadingRepository(this.items);

  final List<DailyReading> items;

  @override
  Future<List<DailyReading>> getAll() async => items;

  @override
  Future<DailyReading> getById(String id) async => items.first;
}

DailyReading buildReading({
  required DateTime date,
  String title = 'Tempo Comum',
  String color = 'verde',
  String details = '',
  String readings = '',
  String body = '',
}) {
  return DailyReading(
    date: date,
    title: title,
    color: color,
    details: details,
    readings: readings,
    body: body,
  );
}

Future<void> pumpWithBloc(
  WidgetTester tester,
  List<DailyReading> items,
  Widget child,
) async {
  final bloc = GenericListBloc<DailyReading, String>(
    getAllUseCase: GetAllUseCase<DailyReading>(
      FakeDailyReadingRepository(items),
    ),
  );
  addTearDown(bloc.close);

  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider<GenericListBloc<DailyReading, String>>.value(
        value: bloc,
        child: child,
      ),
    ),
  );
  await tester.pumpAndSettle();
}
