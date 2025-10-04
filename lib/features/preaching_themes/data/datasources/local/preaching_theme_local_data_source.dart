import 'package:plc/core/storage/local_storage_service.dart';

class PreachingThemeLocalDataSource {
  final LocalStorageService storageService;

  PreachingThemeLocalDataSource({required this.storageService});

  Future<List<String>> getAllPreachingThemes() async {
    try {
      return await storageService.getThemes();
    } catch (e) {
      throw Exception('Failed to load preaching themes from local storage: $e');
    }
  }

  Future<void> savePreachingThemes(List<String> themes) async {
    try {
      await storageService.saveThemes(themes);
    } catch (e) {
      throw Exception('Failed to save preaching themes to local storage: $e');
    }
  }

  Future<DateTime?> getLastSyncDate() async {
    try {
      return await storageService.getThemesLastSyncDate();
    } catch (e) {
      throw Exception('Failed to get preaching themes last sync date: $e');
    }
  }

  Future<void> setLastSyncDate(DateTime date) async {
    try {
      await storageService.setThemesLastSyncDate(date);
    } catch (e) {
      throw Exception('Failed to set preaching themes last sync date: $e');
    }
  }
}
