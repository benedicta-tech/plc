import 'package:flutter_test/flutter_test.dart';
import 'package:plc/features/parishes/data/models/parish_model.dart';

Map<String, dynamic> row({
  String imagem = 'https://exemplo.org/foto.jpg',
  String masculina = 'Sexta, 19h',
}) =>
    {
      'Nome': 'São José',
      'Cidade': 'Pedra Bonita - MG',
      'Imagem': imagem,
      'Perseverança Masculina': masculina,
      'Perseverança Feminina': '',
      'Ordem': '46',
      'Identificação': 'sãojosépedrabonitamg',
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
  });
}
