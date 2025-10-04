import 'dart:async';

/// Simple local storage service for managing preacher data
/// This replaces the SQLite/Floor database with a simple in-memory storage
class LocalStorageService {
  // In-memory storage for preacher data
  final Map<String, dynamic> _storage = {};

  static const String _preachersKey = 'preachers';
  static const String _preachingThemesKey = 'preaching_themes';
  static const String _lastSyncKey = 'last_sync_date';

  /// Get all preachers
  Future<List<Map<String, dynamic>>> getPreachers() async {
    final data = _storage[_preachersKey] as List<dynamic>?;
    return data?.cast<Map<String, dynamic>>() ?? [];
  }

  /// Get preacher by ID
  Future<Map<String, dynamic>?> getPreacherById(int id) async {
    final preachers = await getPreachers();
    try {
      return preachers.firstWhere((preacher) => preacher['id'] == id);
    } catch (e) {
      return null;
    }
  }

  /// Add a new preacher
  Future<void> addPreacher(Map<String, dynamic> preacher) async {
    final preachers = await getPreachers();

    // Generate new ID
    final maxId =
        preachers.isEmpty
            ? 0
            : preachers
                .map((p) => p['id'] as int)
                .reduce((a, b) => a > b ? a : b);

    preacher['id'] = maxId + 1;
    preachers.add(preacher);
    _storage[_preachersKey] = preachers;
  }

  /// Update an existing preacher
  Future<void> updatePreacher(Map<String, dynamic> preacher) async {
    final preachers = await getPreachers();
    final index = preachers.indexWhere((p) => p['id'] == preacher['id']);

    if (index != -1) {
      preachers[index] = preacher;
      _storage[_preachersKey] = preachers;
    }
  }

  /// Delete a preacher
  Future<void> deletePreacher(int id) async {
    final preachers = await getPreachers();
    preachers.removeWhere((preacher) => preacher['id'] == id);
    _storage[_preachersKey] = preachers;
  }

  /// Get all preaching themes
  Future<List<Map<String, dynamic>>> getPreachingThemes() async {
    final data = _storage[_preachingThemesKey] as List<dynamic>?;
    return data?.cast<Map<String, dynamic>>() ?? [];
  }

  /// Save multiple preachers at once (bulk operation)
  Future<void> savePreachers(List<Map<String, dynamic>> preachers) async {
    _storage[_preachersKey] = preachers;
  }

  /// Get last sync date
  Future<DateTime?> getLastSyncDate() async {
    final timestamp = _storage[_lastSyncKey] as int?;
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  /// Set last sync date
  Future<void> setLastSyncDate(DateTime date) async {
    _storage[_lastSyncKey] = date.millisecondsSinceEpoch;
  }

  /// Clear all data (useful for testing)
  Future<void> clear() async {
    _storage.clear();
  }
}
