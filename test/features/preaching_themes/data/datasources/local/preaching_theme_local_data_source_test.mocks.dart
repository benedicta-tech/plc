// Mocks generated manually for preaching_theme_local_data_source_test.dart

import 'package:mockito/mockito.dart' as _i1;
import 'package:plc/core/storage/local_storage_service.dart' as _i2;

class MockLocalStorageService extends _i1.Mock
    implements _i2.LocalStorageService {
  @override
  Future<List<String>> getThemes() => (super.noSuchMethod(
        Invocation.method(#getThemes, []),
        returnValue: Future<List<String>>.value(<String>[]),
      ) as Future<List<String>>);

  @override
  Future<void> saveThemes(List<String>? themes) => (super.noSuchMethod(
        Invocation.method(#saveThemes, [themes]),
        returnValue: Future<void>.value(),
      ) as Future<void>);

  @override
  Future<DateTime?> getThemesLastSyncDate() => (super.noSuchMethod(
        Invocation.method(#getThemesLastSyncDate, []),
        returnValue: Future<DateTime?>.value(),
      ) as Future<DateTime?>);

  @override
  Future<void> setThemesLastSyncDate(DateTime? date) => (super.noSuchMethod(
        Invocation.method(#setThemesLastSyncDate, [date]),
        returnValue: Future<void>.value(),
      ) as Future<void>);
}
