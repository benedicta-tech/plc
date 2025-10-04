import 'package:dio/dio.dart';
import 'package:plc/features/preachers/data/models/preacher_model.dart';

abstract class PreacherRemoteDataSource {
  Future<List<PreacherModel>> getPreachers();
  Future<PreacherModel> getPreacherById(String id);
}

class PreacherRemoteDataSourceImpl implements PreacherRemoteDataSource {
  final Dio dio;
  static const String baseUrl = 'https://plc-app.leigo.fm';

  PreacherRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PreacherModel>> getPreachers() async {
    try {
      final response = await dio.get('$baseUrl/preachers.json');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => PreacherModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: 'Failed to load preachers: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '$baseUrl/preachers.json'),
        type: DioExceptionType.unknown,
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<PreacherModel> getPreacherById(String id) async {
    try {
      final response = await dio.get('$baseUrl/preachers/$id.json');

      if (response.statusCode == 200) {
        return PreacherModel.fromJson(response.data as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: 'Preacher not found',
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: 'Failed to load preacher: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '$baseUrl/preachers/$id.json'),
        type: DioExceptionType.unknown,
        message: 'Unexpected error: $e',
      );
    }
  }
}
