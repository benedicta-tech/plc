import 'package:plc/features/preachers/domain/entities/preacher.dart';

// TODO: remove it to use generic repository implementation
abstract class PreacherRepository {
  Future<List<Preacher>> getPreachers();
  Future<Preacher> getPreacherById(String id);
}
