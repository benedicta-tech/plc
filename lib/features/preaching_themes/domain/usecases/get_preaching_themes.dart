import 'package:plc/features/preaching_themes/domain/repositories/preaching_theme_repository.dart';

class GetPreachingThemes {
  final PreachingThemeRepository repository;

  GetPreachingThemes(this.repository);

  Future<List<String>> call() async {
    return await repository.getPreachingThemes();
  }
}
