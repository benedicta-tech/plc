import 'package:plc/core/storage/local_storage_service.dart';
import 'package:plc/features/preachers/data/models/preacher_model.dart';

/// Local data source for preacher data using simple storage
class PreacherLocalDataSource {
  final LocalStorageService storageService;

  PreacherLocalDataSource({required this.storageService});

  /// Get all preachers from local storage
  Future<List<PreacherModel>> getAllPreachers() async {
    try {
      final jsonList = await storageService.getPreachers();
      return jsonList.map((json) => PreacherModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load preachers from local storage: $e');
    }
  }

  /// Get preacher by ID from local storage
  Future<PreacherModel?> getPreacherById(String id) async {
    try {
      final preachers = await getAllPreachers();
      try {
        return preachers.firstWhere((p) => p.id == id);
      } catch (e) {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to load preacher from local storage: $e');
    }
  }

  /// Save multiple preachers at once (bulk operation)
  Future<void> savePreachers(List<PreacherModel> preachers) async {
    try {
      final jsonList = preachers.map((p) => p.toJson()).toList();
      await storageService.savePreachers(jsonList);
    } catch (e) {
      throw Exception('Failed to save preachers to local storage: $e');
    }
  }

  /// Get last sync date
  Future<DateTime?> getLastSyncDate() async {
    try {
      return await storageService.getLastSyncDate();
    } catch (e) {
      throw Exception('Failed to get last sync date: $e');
    }
  }

  /// Set last sync date
  Future<void> setLastSyncDate(DateTime date) async {
    try {
      await storageService.setLastSyncDate(date);
    } catch (e) {
      throw Exception('Failed to set last sync date: $e');
    }
  }
}
