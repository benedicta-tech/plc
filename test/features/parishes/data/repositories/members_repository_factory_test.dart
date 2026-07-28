import 'package:flutter_test/flutter_test.dart';
import 'package:plc/features/parishes/data/repositories/members_repository_factory.dart';

void main() {
  group('MembersRepositoryFactory.storageKeyFor', () {
    test('deriva uma chave por aba', () {
      expect(
        MembersRepositoryFactory.storageKeyFor('Durandé - São Sebastião'),
        'members_durande_sao_sebastiao',
      );
    });

    test('as 20 abas da planilha não colidem entre si', () {
      // colisão de chave faria uma paróquia exibir os membros de outra
      const abas = [
        'Pocrane - Nossa Senhora da Penha',
        'Durandé - São Sebastião',
        'Martins Soares - Nossa Senhora Mãe dos Homens',
        'Santana do Manhuaçu - Sant’Ana',
        'Caputira - Santa Helena',
        'Luisburgo - São Luiz Gonzaga',
        'Iapu - Santo Estêvão',
        'Santa Rita de Minas - Santa Rita de Cássia',
        'Dom Cavati - Nossa Senhora Aparecida',
        'Ubaporanga - São Domingos de Gusmão',
        'Realeza - Vila Nova - Nossa Senhora do Rosário',
        'Santo Antônio do Manhuaçu - Santo Antônio de Pádua',
        'Tabajara - Santo Antônio de Pádua',
        'Padre Fialho - São João Batista',
        'Pedra Bonita - São José',
        'Matipó - São João Batista',
        'Simonésia - São Simão',
        'Bugre - São Sebastião do Bugre',
        'Manhuaçu - São José',
        'Ipanema - Santo Antônio',
      ];
      final chaves = abas.map(MembersRepositoryFactory.storageKeyFor).toSet();

      expect(chaves.length, abas.length);
      expect(chaves.every((c) => RegExp(r'^members_[a-z0-9_]+$').hasMatch(c)),
          isTrue);
    });

    test('as duas abas de Santo Antônio de Pádua têm chaves distintas', () {
      // matriz e distrito compartilham o nome da paróquia
      expect(
        MembersRepositoryFactory.storageKeyFor(
            'Santo Antônio do Manhuaçu - Santo Antônio de Pádua'),
        isNot(MembersRepositoryFactory.storageKeyFor(
            'Tabajara - Santo Antônio de Pádua')),
      );
    });

    test('a chave não carrega acento, espaço nem pontuação', () {
      final chave =
          MembersRepositoryFactory.storageKeyFor('Santana do Manhuaçu - Sant’Ana');

      expect(chave, matches(RegExp(r'^members_[a-z0-9_]+$')));
    });

    test('a data de sync é uma chave separada da dos dados', () {
      const aba = 'Iapu - Santo Estêvão';

      expect(
        MembersRepositoryFactory.syncKeyFor(aba),
        isNot(MembersRepositoryFactory.storageKeyFor(aba)),
      );
      expect(MembersRepositoryFactory.syncKeyFor(aba),
          startsWith(MembersRepositoryFactory.storageKeyFor(aba)));
    });
  });
}
