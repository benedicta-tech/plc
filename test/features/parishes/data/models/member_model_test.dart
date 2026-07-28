import 'package:flutter_test/flutter_test.dart';
import 'package:plc/features/parishes/data/models/member_model.dart';

Map<String, dynamic> row({
  String nome = 'Ricardo Huebra da Silva',
  String funcao = 'Coordenador',
  String ramo = 'Masculino',
  String encontro = '',
  String palestras = '',
}) =>
    {
      'Nome': nome,
      'Função': funcao,
      'Ramo': ramo,
      'Encontro': encontro,
      'Palestras': palestras,
    };

void main() {
  group('MemberModel.fromJson', () {
    test('lê uma linha da aba da paróquia', () {
      final m = MemberModel.fromJson(row());

      expect(m.name, 'Ricardo Huebra da Silva');
      expect(m.role, 'Coordenador');
      expect(m.branch, 'Masculino');
      expect(m.encounter, isNull);
    });

    test('encontro vazio vira null', () {
      expect(MemberModel.fromJson(row()).encounter, isNull);
      expect(
        MemberModel.fromJson(row(encontro: '2 Encontro do PLC de Pocrane'))
            .encounter,
        '2 Encontro do PLC de Pocrane',
      );
    });

    test('coluna Ramo ausente assume Masculino', () {
      // as abas ganharam a coluna Ramo depois de já terem dados
      final semRamo = row()..remove('Ramo');

      expect(MemberModel.fromJson(semRamo).branch, 'Masculino');
    });

    test('função com sufixo fundação é histórica', () {
      final m = MemberModel.fromJson(row(funcao: 'Coordenador fundação'));

      expect(m.isFounding, isTrue);
      expect(m.roleLabel, 'Coordenador');
    });

    test('função sem sufixo é a vigente', () {
      final m = MemberModel.fromJson(row(funcao: 'Vice-coordenador'));

      expect(m.isFounding, isFalse);
      expect(m.roleLabel, 'Vice-coordenador');
    });

    test('Pároco fundação não se confunde com Pároco', () {
      final paroco = MemberModel.fromJson(row(funcao: 'Pároco'));
      final fundacao = MemberModel.fromJson(row(funcao: 'Pároco fundação'));

      expect(paroco.isFounding, isFalse);
      expect(fundacao.isFounding, isTrue);
      expect(fundacao.roleLabel, 'Pároco');
    });

    test('Palestrante é pregador, não coordenação', () {
      final pregador = MemberModel.fromJson(row(funcao: 'Palestrante'));
      final coordenador = MemberModel.fromJson(row(funcao: 'Coordenador'));

      expect(pregador.isPreacher, isTrue);
      expect(coordenador.isPreacher, isFalse);
      expect(coordenador.isCoordination, isTrue);
      expect(pregador.isCoordination, isFalse);
    });

    test('sem palestras a lista é vazia', () {
      expect(MemberModel.fromJson(row()).lectures, isEmpty);
    });

    test('coluna Palestras ausente não quebra', () {
      final sem = row()..remove('Palestras');

      expect(MemberModel.fromJson(sem).lectures, isEmpty);
    });

    test('uma palestra', () {
      final m = MemberModel.fromJson(row(palestras: 'Biblia'));

      expect(m.lectures, ['Biblia']);
    });

    test('várias palestras separadas por vírgula', () {
      final m = MemberModel.fromJson(
          row(palestras: 'O Ideal, Fé, Perdão'));

      expect(m.lectures, ['O Ideal', 'Fé', 'Perdão']);
    });

    test('tolera espaço sobrando e vírgula sobrando', () {
      final m = MemberModel.fromJson(row(palestras: ' Zaqueu ,,Confissão, '));

      expect(m.lectures, ['Zaqueu', 'Confissão']);
    });

    test('quem tem palestra é pregador mesmo sendo Coordenador', () {
      // é o caso do Emerson em Pocrane: coordenador que prega Bíblia
      final m = MemberModel.fromJson(
          row(funcao: 'Coordenador', palestras: 'Biblia'));

      expect(m.isPreacher, isTrue);
      expect(m.isCoordination, isTrue);
    });

    test('coordenador sem palestra não é pregador', () {
      final m = MemberModel.fromJson(row(funcao: 'Coordenador'));

      expect(m.isPreacher, isFalse);
    });

    test('Pároco não conta como coordenação nem como pregador', () {
      final paroco = MemberModel.fromJson(row(funcao: 'Pároco'));

      expect(paroco.isCoordination, isFalse);
      expect(paroco.isPreacher, isFalse);
      expect(paroco.isPriest, isTrue);
    });

    test('a mesma pessoa pode ser coordenador e pregador', () {
      final coord = MemberModel.fromJson(
          row(nome: 'Emerson Almeida', funcao: 'Coordenador'));
      final preg = MemberModel.fromJson(
          row(nome: 'Emerson Almeida', funcao: 'Palestrante'));

      expect(coord.id, isNot(preg.id));
      expect(coord.name, preg.name);
    });

    test('sobrevive à volta por toJson', () {
      final original = MemberModel.fromJson(
          row(funcao: 'Tesoureiro fundação', encontro: '3 Encontro'));
      final ida = MemberModel.fromJson(original.toJson());

      expect(ida.name, original.name);
      expect(ida.role, original.role);
      expect(ida.branch, original.branch);
      expect(ida.encounter, original.encounter);
    });
  });
}
