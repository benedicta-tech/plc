import 'package:plc/features/preaching_themes/domain/repositories/preaching_theme_repository.dart';

// TODO: remove it when GenericListUseCase is implemented
class GetPreachingThemes {
  final PreachingThemeRepository repository;

  GetPreachingThemes(this.repository);

  Future<List<String>> call() async {
    return await repository.getPreachingThemes();
  }
}
