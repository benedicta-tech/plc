import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:plc/core/features/core_features.dart';
import 'package:plc/core/storage/gsheets_storage_service.dart';
import 'package:plc/core/storage/local_storage_service.dart';
import 'package:plc/features/home/data/models/about_screen_section_model.dart';
import 'package:plc/features/home/domain/entities/about_screen_section.dart';
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
import 'package:plc/features/secretary/data/models/document_model.dart';
import 'package:plc/features/secretary/domain/entities/document.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(() => PreachersBloc(getPreachers: sl()));
  sl.registerFactory(() => PreacherProfileBloc(getPreacherById: sl()));

  sl.registerFactory(
    () => GenericListBloc<Document, String>(
      getAllUseCase: sl<GetAllUseCase<Document>>(),
      searchPredicate: (doc, query) =>
          doc.title.toLowerCase().contains(query.toLowerCase()) ||
          doc.description.toLowerCase().contains(query.toLowerCase()),
      filterPredicate: (doc, category) =>
          category.isEmpty || doc.category == category,
    ),
  );

  sl.registerFactory(
    () => GenericListBloc<AboutScreenSection, String>(
      getAllUseCase: sl<GetAllUseCase<AboutScreenSection>>(),
      searchPredicate: (doc, query) =>
          doc.title.toLowerCase().contains(query.toLowerCase()) ||
          doc.content.toLowerCase().contains(query.toLowerCase()),
      filterPredicate: (doc, category) =>
          category.isEmpty || doc.id == category,
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetPreachers(sl()));
  sl.registerLazySingleton(() => GetPreacherById(sl()));
  sl.registerLazySingleton(() => GetPreachingThemes(sl()));

  sl.registerLazySingleton(() => GetAllUseCase<Document>(sl()));

  sl.registerLazySingleton(() => GetAllUseCase<AboutScreenSection>(sl()));

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

  sl.registerLazySingleton<GenericRepository<Document>>(
    () => GenericCachedRepository<Document, DocumentModel>(
      remoteDataSource: sl<GenericRemoteDataSource<DocumentModel>>(),
      localDataSource: sl<GenericLocalDataSource<DocumentModel>>(),
      cacheDurationInDays: 1,
    ),
  );

  sl.registerLazySingleton<GenericRepository<AboutScreenSection>>(
    () => GenericCachedRepository<AboutScreenSection, AboutScreenSectionModel>(
      remoteDataSource: sl<GenericRemoteDataSource<AboutScreenSectionModel>>(),
      localDataSource: sl<GenericLocalDataSource<AboutScreenSectionModel>>(),
      cacheDurationInDays: 7,
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

  sl.registerLazySingleton<GenericRemoteDataSource<DocumentModel>>(
    () => GenericGSheetsDataSource<DocumentModel>(
      gsheetsService: sl(),
      sheetType: 'main',
      worksheetName: 'Secretaria',
      fromJson: DocumentModel.fromJson,
      sortList: (items) {
        items.sort((a, b) => a.title.compareTo(b.title));
        return items;
      },
    ),
  );

  sl.registerLazySingleton<GenericLocalDataSource<DocumentModel>>(
    () => GenericLocalDataSourceImpl<DocumentModel>(
      storageService: sl(),
      storageKey: 'secretary_documents',
      syncDateKey: 'secretary_documents_last_sync',
      fromJson: DocumentModel.fromJson,
    ),
  );

  sl.registerLazySingleton<GenericRemoteDataSource<AboutScreenSectionModel>>(
    () => GenericGSheetsDataSource<AboutScreenSectionModel>(
      gsheetsService: sl(),
      sheetType: 'main',
      worksheetName: 'Sobre o PLC',
      fromJson: AboutScreenSectionModel.fromJson,
      sortList: (items) {
        items.sort((a, b) => a.order.compareTo(b.order));
        return items;
      },
    ),
  );

  sl.registerLazySingleton<GenericLocalDataSource<AboutScreenSectionModel>>(
    () => GenericLocalDataSourceImpl<AboutScreenSectionModel>(
      storageService: sl(),
      storageKey: 'about_plc_sections',
      syncDateKey: 'about_plc_sections_last_sync',
      fromJson: AboutScreenSectionModel.fromJson,
    ),
  );

  // Core services
  final service = GSheetsStorageService();

  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LocalStorageService());
  sl.registerLazySingleton(() => service);

  await service.initialize();
}
