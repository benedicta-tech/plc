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
import 'package:plc/features/preaching_themes/data/datasources/local/preaching_theme_local_data_source.dart';
import 'package:plc/features/preaching_themes/data/datasources/remote/preaching_theme_remote_data_source.dart';
import 'package:plc/features/preaching_themes/data/repositories/preaching_theme_repository_impl.dart';
import 'package:plc/features/preaching_themes/domain/repositories/preaching_theme_repository.dart';
import 'package:plc/features/preaching_themes/domain/usecases/get_preaching_themes.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(() => PreachersBloc(getPreachers: sl()));
  sl.registerFactory(() => PreacherProfileBloc(getPreacherById: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetPreachers(sl()));
  sl.registerLazySingleton(() => GetPreacherById(sl()));
  sl.registerLazySingleton(() => GetPreachingThemes(sl()));

  // Repository
  sl.registerLazySingleton<PreacherRepository>(
    () => PreacherRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<PreachingThemeRepository>(
    () => PreachingThemeRepositoryImpl(
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
  sl.registerLazySingleton<PreachingThemeRemoteDataSource>(
    () => PreachingThemeRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<PreachingThemeLocalDataSource>(
    () => PreachingThemeLocalDataSource(storageService: sl()),
  );

  // Core services
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LocalStorageService());
}
