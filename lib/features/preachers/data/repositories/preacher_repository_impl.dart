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
      final lastSyncDate = await localDataSource.getLastSyncDate();
      final now = DateTime.now();

      final shouldFetchRemote =
          lastSyncDate == null || now.difference(lastSyncDate).inDays >= 1;

      if (shouldFetchRemote) {
        try {
          final remoteModels = await remoteDataSource.getPreachers();
          await localDataSource.savePreachers(remoteModels);
          await localDataSource.setLastSyncDate(now);
          return remoteModels.map((model) => model.toEntity()).toList();
        } catch (e) {
          final localModels = await localDataSource.getAllPreachers();
          if (localModels.isNotEmpty) {
            return localModels.map((model) => model.toEntity()).toList();
          }
          rethrow;
        }
      } else {
        final preacherModels = await localDataSource.getAllPreachers();
        return preacherModels.map((model) => model.toEntity()).toList();
      }
    } catch (e) {
      throw Exception('Failed to get preachers: $e');
    }
  }

  @override
  Future<Preacher> getPreacherById(String id) async {
    try {
      final preacherModel = await localDataSource.getPreacherById(id);
      if (preacherModel != null) {
        return preacherModel.toEntity();
      }

      try {
        final remoteModel = await remoteDataSource.getPreacherById(id);
        return remoteModel.toEntity();
      } catch (e) {
        throw Exception('Preacher with id $id not found');
      }
    } catch (e) {
      throw Exception('Failed to get preacher by id: $e');
    }
  }
}
