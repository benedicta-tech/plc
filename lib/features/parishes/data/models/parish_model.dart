import 'package:plc/core/features/data/models/entity_model.dart';
import 'package:plc/features/parishes/domain/entities/parish.dart';

class ParishModel extends EntityModel<Parish> {
  @override
  final String id;
  final String name;
  final String location;
  final String perseverance;
  final String? imageUrl;
  final int order;

  ParishModel(
      {required this.id,
      required this.name,
      required this.location,
      required this.perseverance,
      required this.order,
      this.imageUrl});

  factory ParishModel.fromJson(Map<String, dynamic> json) {
    final order = int.tryParse(json['Ordem']?.toString() ?? '') ?? 0;

    return ParishModel(
      id: json['Identificação'] as String? ?? '',
      name: json['Nome'] as String? ?? '',
      location: json['Localização'] as String? ?? '',
      perseverance: json['Peregrinação'] as String? ?? '',
      imageUrl: json['URL Imagem'] as String?,
      order: order,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'Identificação': id,
    };
  }

  @override
  Parish toEntity() {
    // TODO: implement toEntity
    throw UnimplementedError();
  }
}
