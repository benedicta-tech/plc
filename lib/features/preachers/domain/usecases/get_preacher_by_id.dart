import 'package:plc/features/preachers/domain/entities/preacher.dart';
import 'package:plc/features/preachers/domain/repositories/preacher_repository.dart';

class GetPreacherById {
  final PreacherRepository repository;

  GetPreacherById(this.repository);

  Future<Preacher> call(int id) async {
    return await repository.getPreacherById(id);
  }
}
