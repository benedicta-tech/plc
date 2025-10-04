import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:plc/core/storage/local_storage_service.dart';
import 'package:plc/features/preachers/data/datasources/local/preacher_local_data_source.dart';
import 'package:plc/features/preachers/data/datasources/remote/preacher_remote_data_source.dart';
import 'package:plc/features/preachers/data/repositories/preacher_repository_impl.dart';
import 'package:plc/features/preachers/domain/repositories/preacher_repository.dart';
import 'package:plc/features/preachers/domain/usecases/get_preacher_by_id.dart';
import 'package:plc/features/preachers/domain/usecases/get_preachers.dart';
import 'package:plc/features/preachers/presentation/bloc/preacher_profile_bloc.dart';
import 'package:plc/features/preachers/presentation/bloc/preachers_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(() => PreachersBloc(getPreachers: sl()));
  sl.registerFactory(() => PreacherProfileBloc(getPreacherById: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetPreachers(sl()));
  sl.registerLazySingleton(() => GetPreacherById(sl()));

  // Repository
  sl.registerLazySingleton<PreacherRepository>(
    () => PreacherRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<PreacherRemoteDataSource>(
    () => PreacherRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<PreacherLocalDataSource>(
    () => PreacherLocalDataSource(storageService: sl()),
  );

  // Core services
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LocalStorageService());
}
