import 'package:plc/features/preaching_themes/data/datasources/local/preaching_theme_local_data_source.dart';
import 'package:plc/features/preaching_themes/data/datasources/remote/preaching_theme_remote_data_source.dart';
import 'package:plc/features/preaching_themes/domain/repositories/preaching_theme_repository.dart';

class PreachingThemeRepositoryImpl implements PreachingThemeRepository {
  final PreachingThemeRemoteDataSource remoteDataSource;
  final PreachingThemeLocalDataSource localDataSource;

  PreachingThemeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<String>> getPreachingThemes() async {
    try {
      final lastSyncDate = await localDataSource.getLastSyncDate();
      final now = DateTime.now();

      final shouldFetchRemote =
          lastSyncDate == null || now.difference(lastSyncDate).inDays >= 1;

      if (shouldFetchRemote) {
        try {
          final remoteThemes = await remoteDataSource.getPreachingThemes();
          await localDataSource.savePreachingThemes(remoteThemes);
          await localDataSource.setLastSyncDate(now);
          return remoteThemes;
        } catch (e) {
          final localThemes = await localDataSource.getAllPreachingThemes();
          if (localThemes.isNotEmpty) {
            return localThemes;
          }
          rethrow;
        }
      } else {
        final themes = await localDataSource.getAllPreachingThemes();
        return themes;
      }
    } catch (e) {
      throw Exception('Failed to get preaching themes: $e');
    }
  }
}
