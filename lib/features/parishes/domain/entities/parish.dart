import 'package:plc/features/parishes/domain/entities/perseverance.dart';

class Parish {
  final String id;
  final String name;
  final String city;
  final Perseverance perseverance;
  final String? imageUrl;

  Parish({
    required this.id,
    required this.name,
    required this.city,
    required this.perseverance,
    this.imageUrl,
  });

  String get fullName => '$name - $city';
}
