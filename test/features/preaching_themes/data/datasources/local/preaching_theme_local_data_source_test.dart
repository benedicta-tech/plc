import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:plc/core/storage/local_storage_service.dart';
import 'package:plc/features/preaching_themes/data/datasources/local/preaching_theme_local_data_source.dart';

import 'preaching_theme_local_data_source_test.mocks.dart';

@GenerateMocks([LocalStorageService])
void main() {
  late PreachingThemeLocalDataSource dataSource;
  late MockLocalStorageService mockStorageService;

  setUp(() {
    mockStorageService = MockLocalStorageService();
    dataSource =
        PreachingThemeLocalDataSource(storageService: mockStorageService);
  });

  final tPreachingThemes = [
    'Fé',
    'Esperança',
    'Caridade',
    'Oração',
  ];

  group('getAllPreachingThemes', () {
    test('should return preaching themes from storage', () async {
      when(mockStorageService.getThemes())
          .thenAnswer((_) async => tPreachingThemes);

      final result = await dataSource.getAllPreachingThemes();

      expect(result, tPreachingThemes);
      verify(mockStorageService.getThemes());
    });

    test('should throw exception when storage fails', () async {
      when(mockStorageService.getThemes()).thenThrow(Exception('Storage error'));

      expect(
        () => dataSource.getAllPreachingThemes(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('savePreachingThemes', () {
    test('should save preaching themes to storage', () async {
      when(mockStorageService.saveThemes(tPreachingThemes))
          .thenAnswer((_) async => {});

      await dataSource.savePreachingThemes(tPreachingThemes);

      verify(mockStorageService.saveThemes(tPreachingThemes));
    });

    test('should throw exception when storage fails', () async {
      when(mockStorageService.saveThemes(tPreachingThemes))
          .thenThrow(Exception('Storage error'));

      expect(
        () => dataSource.savePreachingThemes(tPreachingThemes),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('getLastSyncDate', () {
    final tDate = DateTime(2025, 1, 1);

    test('should return last sync date from storage', () async {
      when(mockStorageService.getThemesLastSyncDate())
          .thenAnswer((_) async => tDate);

      final result = await dataSource.getLastSyncDate();

      expect(result, tDate);
      verify(mockStorageService.getThemesLastSyncDate());
    });

    test('should return null when no sync date exists', () async {
      when(mockStorageService.getThemesLastSyncDate())
          .thenAnswer((_) async => null);

      final result = await dataSource.getLastSyncDate();

      expect(result, null);
    });

    test('should throw exception when storage fails', () async {
      when(mockStorageService.getThemesLastSyncDate())
          .thenThrow(Exception('Storage error'));

      expect(
        () => dataSource.getLastSyncDate(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('setLastSyncDate', () {
    final tDate = DateTime(2025, 1, 1);

    test('should save sync date to storage', () async {
      when(mockStorageService.setThemesLastSyncDate(tDate))
          .thenAnswer((_) async => {});

      await dataSource.setLastSyncDate(tDate);

      verify(mockStorageService.setThemesLastSyncDate(tDate));
    });

    test('should throw exception when storage fails', () async {
      when(mockStorageService.setThemesLastSyncDate(tDate))
          .thenThrow(Exception('Storage error'));

      expect(
        () => dataSource.setLastSyncDate(tDate),
        throwsA(isA<Exception>()),
      );
    });
  });
}
