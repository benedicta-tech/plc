import 'package:dio/dio.dart';

abstract class PreachingThemeRemoteDataSource {
  Future<List<String>> getPreachingThemes();
}

class PreachingThemeRemoteDataSourceImpl implements PreachingThemeRemoteDataSource {
  final Dio dio;
  static const String baseUrl = 'https://plc-app.leigo.fm';

  PreachingThemeRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<String>> getPreachingThemes() async {
    try {
      final response = await dio.get('$baseUrl/themes.json');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.cast<String>();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: 'Failed to load themes: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '$baseUrl/themes.json'),
        type: DioExceptionType.unknown,
        message: 'Unexpected error: $e',
      );
    }
  }
}
