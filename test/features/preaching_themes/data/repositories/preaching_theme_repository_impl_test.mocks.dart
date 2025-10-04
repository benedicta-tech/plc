// Mocks generated manually for preaching_theme_repository_impl_test.dart

import 'package:mockito/mockito.dart' as _i1;
import 'package:plc/features/preaching_themes/data/datasources/local/preaching_theme_local_data_source.dart'
    as _i2;
import 'package:plc/features/preaching_themes/data/datasources/remote/preaching_theme_remote_data_source.dart'
    as _i3;

class MockPreachingThemeRemoteDataSource extends _i1.Mock
    implements _i3.PreachingThemeRemoteDataSource {
  @override
  Future<List<String>> getPreachingThemes() => (super.noSuchMethod(
        Invocation.method(#getPreachingThemes, []),
        returnValue: Future<List<String>>.value(<String>[]),
      ) as Future<List<String>>);
}

class MockPreachingThemeLocalDataSource extends _i1.Mock
    implements _i2.PreachingThemeLocalDataSource {
  @override
  Future<List<String>> getAllPreachingThemes() => (super.noSuchMethod(
        Invocation.method(#getAllPreachingThemes, []),
        returnValue: Future<List<String>>.value(<String>[]),
      ) as Future<List<String>>);

  @override
  Future<void> savePreachingThemes(List<String>? themes) => (super.noSuchMethod(
        Invocation.method(#savePreachingThemes, [themes]),
        returnValue: Future<void>.value(),
      ) as Future<void>);

  @override
  Future<DateTime?> getLastSyncDate() => (super.noSuchMethod(
        Invocation.method(#getLastSyncDate, []),
        returnValue: Future<DateTime?>.value(),
      ) as Future<DateTime?>);

  @override
  Future<void> setLastSyncDate(DateTime? date) => (super.noSuchMethod(
        Invocation.method(#setLastSyncDate, [date]),
        returnValue: Future<void>.value(),
      ) as Future<void>);
}
