// Mocks generated manually for preaching_theme_remote_data_source_test.dart

import 'package:dio/dio.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

class MockDio extends _i1.Mock implements _i2.Dio {
  @override
  Future<_i2.Response<T>> get<T>(
    String? path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    _i2.Options? options,
    _i2.CancelToken? cancelToken,
    _i2.ProgressCallback? onReceiveProgress,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #get,
          [path],
          {
            #data: data,
            #queryParameters: queryParameters,
            #options: options,
            #cancelToken: cancelToken,
            #onReceiveProgress: onReceiveProgress,
          },
        ),
        returnValue: Future<_i2.Response<T>>.value(_FakeResponse<T>()),
      ) as Future<_i2.Response<T>>);
}

class _FakeResponse<T> extends _i1.Fake implements _i2.Response<T> {}
