// Mocks generated manually for get_preaching_themes_test.dart

import 'package:mockito/mockito.dart' as _i1;
import 'package:plc/features/preaching_themes/domain/repositories/preaching_theme_repository.dart'
    as _i2;

class MockPreachingThemeRepository extends _i1.Mock
    implements _i2.PreachingThemeRepository {
  @override
  Future<List<String>> getPreachingThemes() => (super.noSuchMethod(
        Invocation.method(#getPreachingThemes, []),
        returnValue: Future<List<String>>.value(<String>[]),
      ) as Future<List<String>>);
}
