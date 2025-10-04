import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:plc/features/preaching_themes/domain/repositories/preaching_theme_repository.dart';
import 'package:plc/features/preaching_themes/domain/usecases/get_preaching_themes.dart';

import 'get_preaching_themes_test.mocks.dart';

@GenerateMocks([PreachingThemeRepository])
void main() {
  late GetPreachingThemes usecase;
  late MockPreachingThemeRepository mockRepository;

  setUp(() {
    mockRepository = MockPreachingThemeRepository();
    usecase = GetPreachingThemes(mockRepository);
  });

  final tPreachingThemes = [
    'Fé',
    'Esperança',
    'Caridade',
    'Oração',
  ];

  test('should get preaching themes from the repository', () async {
    when(mockRepository.getPreachingThemes())
        .thenAnswer((_) async => tPreachingThemes);

    final result = await usecase();

    expect(result, tPreachingThemes);
    verify(mockRepository.getPreachingThemes());
    verifyNoMoreInteractions(mockRepository);
  });
}
