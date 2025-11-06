import 'package:plc/core/features/data/models/entity_model.dart';
import 'package:plc/core/storage/local_storage_service.dart';

abstract class GenericLocalDataSource<M extends EntityModel> {
  Future<List<M>> getAll();
  Future<M?> getById(String id);
  Future<void> saveAll(List<M> items);
  Future<DateTime?> getLastSyncDate();
  Future<void> setLastSyncDate(DateTime date);
}

class GenericLocalDataSourceImpl<M extends EntityModel>
    implements GenericLocalDataSource<M> {
  final LocalStorageService storageService;
  final String storageKey;
  final String syncDateKey;
  final M Function(Map<String, dynamic>) fromJson;
  final List<M> Function(List<M>)? filterList;

  GenericLocalDataSourceImpl({
    required this.storageService,
    required this.storageKey,
    required this.syncDateKey,
    required this.fromJson,
    this.filterList,
  });

  @override
  Future<List<M>> getAll() async {
    try {
      final data = await _getStorageData();
      if (data == null) return [];

      var items = (data as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map((json) => fromJson(json))
          .toList();

      if (filterList != null) {
        items = filterList!(items);
      }

      return items;
    } catch (e) {
      throw Exception('Failed to load from local storage: $e');
    }
  }

  @override
  Future<M?> getById(String id) async {
    try {
      final items = await getAll();
      return items.cast<M?>().firstWhere(
            (item) => item?.id == id,
            orElse: () => null,
          );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveAll(List<M> items) async {
    try {
      final jsonList = items.map((item) => item.toJson()).toList();
      await _setStorageData(jsonList);
    } catch (e) {
      throw Exception('Failed to save to local storage: $e');
    }
  }

  @override
  Future<DateTime?> getLastSyncDate() async {
    try {
      final timestamp = await _getSyncTimestamp();
      return timestamp != null
          ? DateTime.fromMillisecondsSinceEpoch(timestamp)
          : null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> setLastSyncDate(DateTime date) async {
    try {
      await _setSyncTimestamp(date.millisecondsSinceEpoch);
    } catch (e) {
      throw Exception('Failed to set last sync date: $e');
    }
  }

  Future<dynamic> _getStorageData() async {
    return await storageService.get(storageKey);
  }

  Future<void> _setStorageData(List<Map<String, dynamic>> data) async {
    await storageService.set(storageKey, data);
  }

  Future<int?> _getSyncTimestamp() async {
    return await storageService.get(syncDateKey) as int?;
  }

  Future<void> _setSyncTimestamp(int timestamp) async {
    await storageService.set(syncDateKey, timestamp);
  }
}
