import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plc/features/parishes/domain/entities/member.dart';
import 'package:plc/features/parishes/presentation/widgets/parish_members_view.dart';

Member member(String name, String role, {String branch = 'Masculino'}) =>
    Member(name: name, role: role, branch: branch);

Future<void> render(WidgetTester tester, List<Member> members) =>
    tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(child: ParishMembersView(members: members)),
      ),
    ));

void main() {
  group('ParishMembersView', () {
    testWidgets('mostra a coordenação vigente do ramo masculino', (t) async {
      await render(t, [
        member('Ricardo Huebra da Silva', 'Coordenador'),
        member('Valdece Vieira da Silva', 'Vice-coordenador'),
      ]);

      expect(find.text('Coordenação masculina'), findsOneWidget);
      expect(find.text('Ricardo Huebra da Silva'), findsOneWidget);
      expect(find.text('Coordenador'), findsOneWidget);
    });

    testWidgets('separa os ramos masculino e feminino', (t) async {
      await render(t, [
        member('João', 'Coordenador'),
        member('Maria', 'Coordenador', branch: 'Feminino'),
      ]);

      expect(find.text('Coordenação masculina'), findsOneWidget);
      expect(find.text('Coordenação feminina'), findsOneWidget);
      expect(find.text('João'), findsOneWidget);
      expect(find.text('Maria'), findsOneWidget);
    });

    testWidgets('omite o ramo que não tem ninguém', (t) async {
      await render(t, [member('João', 'Coordenador')]);

      expect(find.text('Coordenação masculina'), findsOneWidget);
      expect(find.text('Coordenação feminina'), findsNothing);
    });

    testWidgets('lista os pregadores em seção própria', (t) async {
      await render(t, [
        member('Emerson Almeida', 'Coordenador'),
        member('Emerson Almeida', 'Palestrante'),
      ]);

      expect(find.text('Pregadores'), findsOneWidget);
      // a mesma pessoa aparece nas duas seções, por acumular papéis
      expect(find.text('Emerson Almeida'), findsNWidgets(2));
    });

    testWidgets('coordenador que prega aparece nas duas seções', (t) async {
      // o caso do Emerson em Pocrane: Coordenador com Palestras = Biblia
      await render(t, [
        Member(
          name: 'Emerson Almeida',
          role: 'Coordenador',
          branch: 'Masculino',
          lectures: const ['Biblia'],
        ),
      ]);

      expect(find.text('Coordenação masculina'), findsOneWidget);
      expect(find.text('Pregadores'), findsOneWidget);
      expect(find.text('Emerson Almeida'), findsNWidgets(2));
    });

    testWidgets('mostra quais pregações a pessoa faz', (t) async {
      await render(t, [
        Member(
          name: 'Emerson Almeida',
          role: 'Coordenador',
          branch: 'Masculino',
          lectures: const ['O Ideal', 'Bíblia'],
        ),
      ]);

      expect(find.textContaining('O Ideal'), findsOneWidget);
      expect(find.textContaining('Bíblia'), findsOneWidget);
    });

    testWidgets('o pároco fica fora da coordenação', (t) async {
      await render(t, [
        member('Pe. Matias José Pereira', 'Pároco'),
        member('Altair Almeida Teixeira', 'Coordenador'),
      ]);

      expect(find.text('Pároco'), findsOneWidget);
      expect(find.text('Pe. Matias José Pereira'), findsOneWidget);
      expect(find.text('Coordenação masculina'), findsOneWidget);
    });

    testWidgets('a coordenação de fundação não aparece na tela', (t) async {
      await render(t, [
        member('Ricardo Huebra da Silva', 'Coordenador'),
        member('Gilmar Camilo Pereira da Silva', 'Coordenador fundação'),
      ]);

      expect(find.text('Coordenação de fundação'), findsNothing);
      expect(find.text('Gilmar Camilo Pereira da Silva'), findsNothing);
      expect(find.text('Ricardo Huebra da Silva'), findsOneWidget);
    });

    testWidgets('paróquia só com fundação não renderiza nada', (t) async {
      // é o caso da maioria das abas: 79 pessoas de fundação contra 34 vigentes
      await render(t, [
        member('José Pascoaline Pinto', 'Coordenador fundação'),
        member('Antônio Machado', 'Vice-coordenador fundação'),
      ]);

      expect(find.text('Coordenação masculina'), findsNothing);
      expect(find.text('Coordenação de fundação'), findsNothing);
      expect(find.text('José Pascoaline Pinto'), findsNothing);
    });

    testWidgets('pároco de fundação também fica fora', (t) async {
      await render(t, [member('Pe. Eder Mateus', 'Pároco fundação')]);

      expect(find.text('Pároco'), findsNothing);
      expect(find.text('Pe. Eder Mateus'), findsNothing);
    });

    testWidgets('masculino em verde e feminino em rosa', (t) async {
      await render(t, [
        member('João', 'Coordenador'),
        member('Maria', 'Coordenador', branch: 'Feminino'),
      ]);

      Color? corDoTitulo(String texto) =>
          t.widget<Text>(find.text(texto)).style?.color;

      expect(corDoTitulo('Coordenação masculina'),
          ParishMembersView.masculineColor);
      expect(
          corDoTitulo('Coordenação feminina'), ParishMembersView.feminineColor);
    });

    testWidgets('sem membro nenhum não renderiza seção alguma', (t) async {
      await render(t, []);

      expect(find.text('Coordenação masculina'), findsNothing);
      expect(find.text('Pregadores'), findsNothing);
      expect(find.text('Pároco'), findsNothing);
    });

    testWidgets('o encontro da pessoa não entra na lista', (t) async {
      await render(t, [
        Member(
          name: 'Emerson Almeida',
          role: 'Coordenador',
          branch: 'Masculino',
          encounter: '2 Encontro do PLC de Pocrane',
        ),
      ]);

      expect(find.text('Emerson Almeida'), findsOneWidget);
      expect(find.text('Coordenador'), findsOneWidget);
      expect(find.textContaining('Encontro'), findsNothing);
    });
  });
}
