import 'package:plc/features/parishes/data/datasources/parish_remote_data_source.dart';
import 'package:plc/features/parishes/domain/entities/parish.dart';
import 'package:plc/features/parishes/domain/repository/parish_repository.dart';
import 'package:plc/features/preachers/data/datasources/local/preacher_local_data_source.dart';
import 'package:plc/features/preachers/data/datasources/remote/preacher_remote_data_source.dart';
import 'package:plc/features/preachers/domain/entities/preacher.dart';
import 'package:plc/features/preachers/domain/repositories/preacher_repository.dart';

class ParishRepositoryImpl implements ParishRepository {
  final ParishDataSource remoteDataSource;
  // final ParishLocalDataSource localDataSource;

  // TODO: Implement local data source and caching logic
  ParishRepositoryImpl({
    required this.remoteDataSource,
    // required this.localDataSource,
  });

  @override
  Future<List<Parish>> getParishes() async {
    try {
      // final lastSyncDate = await localDataSource.getLastSyncDate();
      // final now = DateTime.now();

      // final shouldFetchRemote =
      //     lastSyncDate == null || now.difference(lastSyncDate).inDays >= 1;

      // if (shouldFetchRemote) {
      try {
        final remoteModels = await remoteDataSource.getParishes();
        // await localDataSource.saveParishes(remoteModels);
        // await localDataSource.setLastSyncDate(now);
        return remoteModels.map((model) => model.toEntity()).toList();
      } catch (e) {
        // final localModels = await localDataSource.getAllParishes();
        // if (localModels.isNotEmpty) {
        //   return localModels.map((model) => model.toEntity()).toList();
        // }
        rethrow;
      }
      // } else {
      //   final preacherModels = await localDataSource.getAllParishes();
      //   return preacherModels.map((model) => model.toEntity()).toList();
      // }
    } catch (e) {
      throw Exception('Failed to get preachers: $e');
    }
  }
}
