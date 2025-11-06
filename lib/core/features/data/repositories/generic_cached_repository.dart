import 'package:plc/core/features/data/datasources/generic_local_data_source.dart';
import 'package:plc/core/features/data/datasources/generic_remote_data_source.dart';
import 'package:plc/core/features/data/models/entity_model.dart';
import 'package:plc/core/features/domain/repositories/generic_repository.dart';

class GenericCachedRepository<T, M extends EntityModel<T>>
    implements GenericRepository<T> {
  final GenericRemoteDataSource<M> remoteDataSource;
  final GenericLocalDataSource<M> localDataSource;
  final int cacheDurationInDays;

  GenericCachedRepository({
    required this.remoteDataSource,
    required this.localDataSource,
    this.cacheDurationInDays = 1,
  });

  @override
  Future<List<T>> getAll() async {
    try {
      final lastSyncDate = await localDataSource.getLastSyncDate();
      final now = DateTime.now();

      final shouldFetchRemote = lastSyncDate == null ||
          now.difference(lastSyncDate).inDays >= cacheDurationInDays;

      if (shouldFetchRemote) {
        try {
          final remoteModels = await remoteDataSource.getAll();
          await localDataSource.saveAll(remoteModels);
          await localDataSource.setLastSyncDate(now);
          return remoteModels.map((model) => model.toEntity()).toList();
        } catch (e) {
          final localModels = await localDataSource.getAll();
          if (localModels.isNotEmpty) {
            return localModels.map((model) => model.toEntity()).toList();
          }
          rethrow;
        }
      } else {
        final localModels = await localDataSource.getAll();
        return localModels.map((model) => model.toEntity()).toList();
      }
    } catch (e) {
      throw Exception('Failed to get items: $e');
    }
  }

  @override
  Future<T> getById(String id) async {
    try {
      final localModel = await localDataSource.getById(id);
      if (localModel != null) {
        return localModel.toEntity();
      }

      try {
        final remoteModel = await remoteDataSource.getById(id);
        return remoteModel.toEntity();
      } catch (e) {
        throw Exception('Item with id $id not found');
      }
    } catch (e) {
      throw Exception('Failed to get item by id: $e');
    }
  }
}
