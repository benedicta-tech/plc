import 'package:dio/dio.dart';
import 'package:plc/features/preachers/data/models/preacher_model.dart';

abstract class PreacherRemoteDataSource {
  Future<List<PreacherModel>> getPreachers();
  Future<PreacherModel> getPreacherById(int id);
}

class PreacherRemoteDataSourceImpl implements PreacherRemoteDataSource {
  final Dio dio;

  PreacherRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PreacherModel>> getPreachers() async {
    // TODO: Implement API call
    return [];
  }

  @override
  Future<PreacherModel> getPreacherById(int id) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }
}
