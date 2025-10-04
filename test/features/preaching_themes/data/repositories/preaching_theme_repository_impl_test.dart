import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:plc/features/preaching_themes/data/datasources/local/preaching_theme_local_data_source.dart';
import 'package:plc/features/preaching_themes/data/datasources/remote/preaching_theme_remote_data_source.dart';
import 'package:plc/features/preaching_themes/data/repositories/preaching_theme_repository_impl.dart';

import 'preaching_theme_repository_impl_test.mocks.dart';

@GenerateMocks([
  PreachingThemeRemoteDataSource,
  PreachingThemeLocalDataSource,
])
void main() {
  late PreachingThemeRepositoryImpl repository;
  late MockPreachingThemeRemoteDataSource mockRemoteDataSource;
  late MockPreachingThemeLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockPreachingThemeRemoteDataSource();
    mockLocalDataSource = MockPreachingThemeLocalDataSource();
    repository = PreachingThemeRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tPreachingThemes = [
    'Fé',
    'Esperança',
    'Caridade',
    'Oração',
  ];

  group('getPreachingThemes', () {
    test(
      'should fetch from remote when no last sync date exists',
      () async {
        when(mockLocalDataSource.getLastSyncDate())
            .thenAnswer((_) async => null);
        when(mockRemoteDataSource.getPreachingThemes())
            .thenAnswer((_) async => tPreachingThemes);
        when(mockLocalDataSource.savePreachingThemes(tPreachingThemes))
            .thenAnswer((_) async => {});
        when(mockLocalDataSource.setLastSyncDate(any))
            .thenAnswer((_) async => {});

        final result = await repository.getPreachingThemes();

        expect(result, tPreachingThemes);
        verify(mockLocalDataSource.getLastSyncDate());
        verify(mockRemoteDataSource.getPreachingThemes());
        verify(mockLocalDataSource.savePreachingThemes(tPreachingThemes));
        verify(mockLocalDataSource.setLastSyncDate(any));
      },
    );

    test(
      'should fetch from remote when last sync was 1 day ago or more',
      () async {
        final oldDate = DateTime.now().subtract(const Duration(days: 1));
        when(mockLocalDataSource.getLastSyncDate())
            .thenAnswer((_) async => oldDate);
        when(mockRemoteDataSource.getPreachingThemes())
            .thenAnswer((_) async => tPreachingThemes);
        when(mockLocalDataSource.savePreachingThemes(tPreachingThemes))
            .thenAnswer((_) async => {});
        when(mockLocalDataSource.setLastSyncDate(any))
            .thenAnswer((_) async => {});

        final result = await repository.getPreachingThemes();

        expect(result, tPreachingThemes);
        verify(mockLocalDataSource.getLastSyncDate());
        verify(mockRemoteDataSource.getPreachingThemes());
        verify(mockLocalDataSource.savePreachingThemes(tPreachingThemes));
        verify(mockLocalDataSource.setLastSyncDate(any));
      },
    );

    test(
      'should return local data when last sync was less than 1 day ago',
      () async {
        final recentDate = DateTime.now().subtract(const Duration(hours: 12));
        when(mockLocalDataSource.getLastSyncDate())
            .thenAnswer((_) async => recentDate);
        when(mockLocalDataSource.getAllPreachingThemes())
            .thenAnswer((_) async => tPreachingThemes);

        final result = await repository.getPreachingThemes();

        expect(result, tPreachingThemes);
        verify(mockLocalDataSource.getLastSyncDate());
        verify(mockLocalDataSource.getAllPreachingThemes());
        verifyNever(mockRemoteDataSource.getPreachingThemes());
      },
    );

    test(
      'should return local data when remote fetch fails and local data exists',
      () async {
        when(mockLocalDataSource.getLastSyncDate())
            .thenAnswer((_) async => null);
        when(mockRemoteDataSource.getPreachingThemes())
            .thenThrow(Exception('Network error'));
        when(mockLocalDataSource.getAllPreachingThemes())
            .thenAnswer((_) async => tPreachingThemes);

        final result = await repository.getPreachingThemes();

        expect(result, tPreachingThemes);
        verify(mockLocalDataSource.getLastSyncDate());
        verify(mockRemoteDataSource.getPreachingThemes());
        verify(mockLocalDataSource.getAllPreachingThemes());
      },
    );

    test(
      'should throw exception when remote fetch fails and no local data exists',
      () async {
        when(mockLocalDataSource.getLastSyncDate())
            .thenAnswer((_) async => null);
        when(mockRemoteDataSource.getPreachingThemes())
            .thenThrow(Exception('Network error'));
        when(mockLocalDataSource.getAllPreachingThemes())
            .thenAnswer((_) async => []);

        expect(
          () => repository.getPreachingThemes(),
          throwsA(isA<Exception>()),
        );
      },
    );
  });
}
