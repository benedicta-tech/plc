import 'package:plc/features/preachers/domain/entities/preacher.dart';
import 'package:plc/features/preachers/domain/repositories/preacher_repository.dart';

class GetPreachers {
  final PreacherRepository repository;

  GetPreachers(this.repository);

  Future<List<Preacher>> call() async {
    return await repository.getPreachers();
  }
}
