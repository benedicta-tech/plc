import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:plc/features/preaching_themes/data/datasources/remote/preaching_theme_remote_data_source.dart';

import 'preaching_theme_remote_data_source_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late PreachingThemeRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = PreachingThemeRemoteDataSourceImpl(dio: mockDio);
  });

  final tPreachingThemes = [
    'Fé',
    'Esperança',
    'Caridade',
    'Oração',
  ];

  group('getPreachingThemes', () {
    test('should return list of themes when the response code is 200', () async {
      when(
        mockDio.get('https://plc-app.leigo.fm/themes.json'),
      ).thenAnswer(
        (_) async => Response(
          data: tPreachingThemes,
          statusCode: 200,
          requestOptions: RequestOptions(
            path: 'https://plc-app.leigo.fm/themes.json',
          ),
        ),
      );

      final result = await dataSource.getPreachingThemes();

      expect(result, tPreachingThemes);
      verify(mockDio.get('https://plc-app.leigo.fm/themes.json'));
    });

    test('should throw DioException when the response code is not 200', () async {
      when(
        mockDio.get('https://plc-app.leigo.fm/themes.json'),
      ).thenAnswer(
        (_) async => Response(
          data: null,
          statusCode: 404,
          requestOptions: RequestOptions(
            path: 'https://plc-app.leigo.fm/themes.json',
          ),
        ),
      );

      expect(
        () => dataSource.getPreachingThemes(),
        throwsA(isA<DioException>()),
      );
    });

    test('should rethrow DioException when Dio throws', () async {
      when(
        mockDio.get('https://plc-app.leigo.fm/themes.json'),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(
            path: 'https://plc-app.leigo.fm/themes.json',
          ),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      expect(
        () => dataSource.getPreachingThemes(),
        throwsA(isA<DioException>()),
      );
    });

    test('should throw DioException when an unexpected error occurs', () async {
      when(
        mockDio.get('https://plc-app.leigo.fm/themes.json'),
      ).thenThrow(Exception('Unexpected error'));

      expect(
        () => dataSource.getPreachingThemes(),
        throwsA(isA<DioException>()),
      );
    });
  });
}
