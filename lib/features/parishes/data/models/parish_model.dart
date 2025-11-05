import 'package:plc/features/parishes/domain/entities/parish.dart';

class ParishModel {
  final String id;
  final String name;
  final String location;
  final String perseverance;
  final String? imageUrl;

  ParishModel(
      {required this.id,
      required this.name,
      required this.location,
      required this.perseverance,
      this.imageUrl});

  Parish toEntity() {
    return Parish(
        id: id,
        name: name,
        location: location,
        perseverance: perseverance,
        imageUrl: imageUrl);
  }
}
