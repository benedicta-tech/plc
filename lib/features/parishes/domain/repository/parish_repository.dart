import 'package:plc/features/parishes/domain/entities/parish.dart';

abstract class ParishRepository {
  Future<List<Parish>> getParishes();
}
