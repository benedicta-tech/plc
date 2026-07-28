import 'package:flutter_test/flutter_test.dart';
import 'package:plc/features/parishes/data/models/parish_model.dart';

Map<String, dynamic> row({
  String imagem = 'https://exemplo.org/foto.jpg',
  String masculina = 'Sexta, 19h',
  String fundacao = '1932',
  String chegadaPlc = '2023',
  String abaMembros = 'Pedra Bonita - São José',
}) =>
    {
      'Nome': 'São José',
      'Cidade': 'Pedra Bonita - MG',
      'Imagem': imagem,
      'Perseverança Masculina': masculina,
      'Perseverança Feminina': '',
      'Ordem': '46',
      'Identificação': 'sãojosépedrabonitamg',
      'Fundação da paróquia': fundacao,
      'Chegada do PLC': chegadaPlc,
      'Aba de membros': abaMembros,
    };

void main() {
  group('ParishModel.fromJson', () {
    test('lê os campos da planilha', () {
      final parish = ParishModel.fromJson(row());

      expect(parish.id, 'sãojosépedrabonitamg');
      expect(parish.name, 'São José');
      expect(parish.city, 'Pedra Bonita - MG');
      expect(parish.order, 46);
      expect(parish.imageUrl, 'https://exemplo.org/foto.jpg');
      expect(parish.perseverance.male, 'Sexta, 19h');
      expect(parish.perseverance.female, isNull);
    });

    test('célula de imagem vazia vira null, não string vazia', () {
      // a planilha entrega '' para célula vazia, e as telas fazem
      // Image.network(imageUrl!) sem errorBuilder
      final parish = ParishModel.fromJson(row(imagem: ''));

      expect(parish.imageUrl, isNull);
    });

    test('coluna de imagem ausente vira null', () {
      final semColuna = row()..remove('Imagem');

      expect(ParishModel.fromJson(semColuna).imageUrl, isNull);
    });

    test('paróquia sem imagem continua com perseverança e aparece na lista', () {
      final parish = ParishModel.fromJson(row(imagem: ''));

      expect(parish.imageUrl, isNull);
      expect(parish.hasPerseverance, isTrue);
    });

    test('sem perseverança nenhuma fica fora da lista', () {
      final parish = ParishModel.fromJson(row(masculina: ''));

      expect(parish.hasPerseverance, isFalse);
    });

    test('lê fundação, chegada do PLC e a aba de membros', () {
      final parish = ParishModel.fromJson(row());

      expect(parish.foundation, '1932');
      expect(parish.plcArrival, '2023');
      expect(parish.membersSheet, 'Pedra Bonita - São José');
    });

    test('colunas históricas vazias viram null', () {
      final parish = ParishModel.fromJson(
          row(fundacao: '', chegadaPlc: '', abaMembros: ''));

      expect(parish.foundation, isNull);
      expect(parish.plcArrival, isNull);
      expect(parish.membersSheet, isNull);
      expect(parish.hasMembers, isFalse);
    });

    test('colunas históricas ausentes viram null', () {
      // o Sheets trunca células vazias à direita, então a chave some da linha
      final curta = row()
        ..remove('Fundação da paróquia')
        ..remove('Chegada do PLC')
        ..remove('Aba de membros');
      final parish = ParishModel.fromJson(curta);

      expect(parish.foundation, isNull);
      expect(parish.plcArrival, isNull);
      expect(parish.membersSheet, isNull);
    });

    test('só tem membros quando a aba está apontada', () {
      expect(ParishModel.fromJson(row()).hasMembers, isTrue);
      expect(ParishModel.fromJson(row(abaMembros: '')).hasMembers, isFalse);
    });

    test('preserva o histórico na volta por toJson', () {
      final ida = ParishModel.fromJson(ParishModel.fromJson(row()).toJson());

      expect(ida.foundation, '1932');
      expect(ida.plcArrival, '2023');
      expect(ida.membersSheet, 'Pedra Bonita - São José');
    });
  });
}
