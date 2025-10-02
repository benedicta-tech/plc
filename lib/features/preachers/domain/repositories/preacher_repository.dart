import 'package:plc/features/preachers/domain/entities/preacher.dart';

abstract class PreacherRepository {
  Future<List<Preacher>> getPreachers();
  Future<Preacher> getPreacherById(int id);
}
