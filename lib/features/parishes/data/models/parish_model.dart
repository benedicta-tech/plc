import 'package:plc/core/features/data/models/entity_model.dart';
import 'package:plc/features/parishes/data/models/perseverance_model.dart';
import 'package:plc/features/parishes/domain/entities/parish.dart';

class ParishModel extends EntityModel<Parish> {
  @override
  final String id;
  final String name;
  final String city;
  final PerseveranceModel perseverance;
  final String? imageUrl;
  final int order;
  final String? foundation;
  final String? plcArrival;
  final String? membersSheet;

  ParishModel(
      {required this.id,
      required this.name,
      required this.city,
      required this.perseverance,
      required this.order,
      this.imageUrl,
      this.foundation,
      this.plcArrival,
      this.membersSheet});

  factory ParishModel.fromJson(Map<String, dynamic> json) {
    final order = int.tryParse(json['Ordem']?.toString() ?? '') ?? 0;
    final id = json['Identificação'] as String? ?? '';

    /// O Sheets trunca células vazias à direita, então a coluna some da linha
    /// em vez de vir como string vazia.
    String? opcional(String coluna) {
      final valor = (json[coluna] as String?)?.trim();
      return valor != null && valor.isNotEmpty ? valor : null;
    }

    return ParishModel(
      id: id,
      name: json['Nome'] as String? ?? '',
      city: json['Cidade'] as String? ?? '',
      perseverance: PerseveranceModel.fromParishJson(
          id: id,
          male: json['Perseverança Masculina'],
          female: json['Perseverança Feminina']),
      imageUrl: opcional('Imagem'),
      order: order,
      foundation: opcional('Fundação da paróquia'),
      plcArrival: opcional('Chegada do PLC'),
      membersSheet: opcional('Aba de membros'),
    );
  }

  bool get hasPerseverance =>
      perseverance.male != null || perseverance.female != null;

  bool get hasMembers => membersSheet != null;

  @override
  Map<String, dynamic> toJson() {
    return {
      'Identificação': id,
      'Nome': name,
      'Cidade': city,
      'Perseverança Masculina': perseverance.male,
      'Perseverança Feminina': perseverance.female,
      'Imagem': imageUrl,
      'Ordem': order,
      'Fundação da paróquia': foundation,
      'Chegada do PLC': plcArrival,
      'Aba de membros': membersSheet,
    };
  }

  @override
  Parish toEntity() {
    return Parish(
      id: id,
      name: name,
      city: city,
      perseverance: perseverance.toEntity(),
      imageUrl: imageUrl,
      foundation: foundation,
      plcArrival: plcArrival,
      membersSheet: membersSheet,
    );
  }
}
