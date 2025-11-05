import 'package:plc/features/parishes/domain/entities/parish.dart';
import 'package:plc/features/parishes/domain/repository/parish_repository.dart';

class GetParishes {
  final ParishRepository repository;

  GetParishes(this.repository);

  Future<List<Parish>> call() async {
    return await repository.getParishes();
  }
}
