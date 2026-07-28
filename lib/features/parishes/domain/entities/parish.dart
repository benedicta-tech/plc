import 'package:plc/features/parishes/domain/entities/perseverance.dart';

class Parish {
  final String id;
  final String name;
  final String city;
  final Perseverance perseverance;
  final String? imageUrl;

  /// Ano em que a paróquia foi criada, vindo do site da diocese.
  final String? foundation;

  /// Ano em que o PLC chegou à paróquia, que é bem posterior à fundação.
  final String? plcArrival;

  /// Título da aba onde ficam os membros desta paróquia. Não é derivável do
  /// nome nem da cidade: nos distritos a aba usa o nome do distrito.
  final String? membersSheet;

  Parish({
    required this.id,
    required this.name,
    required this.city,
    required this.perseverance,
    this.imageUrl,
    this.foundation,
    this.plcArrival,
    this.membersSheet,
  });

  String get fullName => '$name - $city';

  bool get hasMembers => membersSheet != null;
}
