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

  ParishModel(
      {required this.id,
      required this.name,
      required this.city,
      required this.perseverance,
      required this.order,
      this.imageUrl});

  factory ParishModel.fromJson(Map<String, dynamic> json) {
    final order = int.tryParse(json['Ordem']?.toString() ?? '') ?? 0;
    final id = json['Identificação'] as String? ?? '';

    return ParishModel(
      id: json['Identificação'] as String? ?? '',
      name: json['Nome'] as String? ?? '',
      city: json['Cidade'] as String? ?? '',
      perseverance: PerseveranceModel(
          id: id,
          male: json['Perseverança Masculina'],
          female: json['Perseverança Feminina']),
      imageUrl: json['URL Imagem'] as String?,
      order: order,
    );
  }

  bool get hasPerseverance =>
      (perseverance.male != null && perseverance.male!.isNotEmpty) ||
      (perseverance.female != null && perseverance.female!.isNotEmpty);

  @override
  Map<String, dynamic> toJson() {
    return {
      'Identificação': id,
      'Nome': name,
      'Cidade': city,
      'Perseverança Masculina': perseverance.male,
      'Perseverança Feminina': perseverance.female,
      'URL Imagem': imageUrl,
      'Ordem': order,
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
    );
  }
}
