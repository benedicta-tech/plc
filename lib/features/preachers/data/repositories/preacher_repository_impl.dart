import 'package:plc/features/preachers/data/datasources/local/preacher_local_data_source.dart';
import 'package:plc/features/preachers/data/datasources/remote/preacher_remote_data_source.dart';
import 'package:plc/features/preachers/domain/entities/preacher.dart';
import 'package:plc/features/preachers/domain/repositories/preacher_repository.dart';

class PreacherRepositoryImpl implements PreacherRepository {
  final PreacherRemoteDataSource remoteDataSource;
  final PreacherLocalDataSource localDataSource;

  PreacherRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Preacher>> getPreachers() async {
    try {
      // For now, we'll use local data only (offline-first approach)
      // In the future, this can be enhanced to sync with remote data
      final preacherModels = await localDataSource.getAllPreachers();
      return preacherModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get preachers: $e');
    }
  }

  @override
  Future<Preacher> getPreacherById(int id) async {
    try {
      final preacherModel = await localDataSource.getPreacherById(id);
      if (preacherModel != null) {
        return preacherModel.toEntity();
      } else {
        throw Exception('Preacher with id $id not found');
      }
    } catch (e) {
      throw Exception('Failed to get preacher by id: $e');
    }
  }
}
