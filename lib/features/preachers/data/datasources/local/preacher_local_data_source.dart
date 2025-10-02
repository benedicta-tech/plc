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
  Future<PreacherModel?> getPreacherById(int id) async {
    try {
      final json = await storageService.getPreacherById(id);
      if (json != null) {
        return PreacherModel.fromJson(json);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to load preacher from local storage: $e');
    }
  }

  /// Add a new preacher to local storage
  Future<void> addPreacher(PreacherModel preacher) async {
    try {
      await storageService.addPreacher(preacher.toJson());
    } catch (e) {
      throw Exception('Failed to add preacher to local storage: $e');
    }
  }

  /// Update an existing preacher in local storage
  Future<void> updatePreacher(PreacherModel preacher) async {
    try {
      await storageService.updatePreacher(preacher.toJson());
    } catch (e) {
      throw Exception('Failed to update preacher in local storage: $e');
    }
  }

  /// Delete a preacher from local storage
  Future<void> deletePreacher(int id) async {
    try {
      await storageService.deletePreacher(id);
    } catch (e) {
      throw Exception('Failed to delete preacher from local storage: $e');
    }
  }
}
