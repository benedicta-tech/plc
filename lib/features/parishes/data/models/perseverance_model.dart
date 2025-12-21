import 'package:plc/core/features/data/models/entity_model.dart';
import 'package:plc/features/parishes/domain/entities/perseverance.dart';

class PerseveranceModel extends EntityModel<Perseverance> {
  @override
  final String id;
  final String? male;
  final String? female;
  PerseveranceModel(
      {required this.id, required this.male, required this.female});

  @override
  Perseverance toEntity() {
    return Perseverance(male: male, female: female);
  }

  factory PerseveranceModel.fromParishJson(
      {required String id, String? male, String? female}) {
    return PerseveranceModel(
        id: id,
        male: male != null && male.isNotEmpty ? male : null,
        female: female != null && female.isNotEmpty ? female : null);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'Identificação': id,
      'Masculina': male,
      'Feminina': female,
    };
  }
}
