import 'package:get_it/get_it.dart';

import '../network/api_service.dart';
import '../network/dio_client.dart';
import '../network/interceptors/auth_interceptor.dart';
import '../network/interceptors/error_interceptor.dart';
import '../network/interceptors/log_interceptor.dart';
import '../network/network_config.dart';
import '../storage/hive_local_storage.dart';
import '../storage/local_storage.dart';

// --- Auth local ---
import '../../features/auth/data/data_sources/auth_local_data_source_impl.dart';
import '../../features/auth/domain/data_source.dart/auth_local_data_source.dart';

// --- Auth ---
import '../../features/auth/data/data_sources/auth_remote_data_source_impl.dart';
import '../../features/auth/data/repo/auth_repo_impl.dart';
import '../../features/auth/domain/data_source.dart/auth_remote_data_source.dart';
import '../../features/auth/domain/repo/auth_repo.dart';
import '../../features/auth/presentation/manager/login_cubit/login_cubit.dart';
import '../../features/auth/presentation/manager/signup_cubit/signup_cubit.dart';

// --- Home ---
import '../../features/home/data/data_sources/home_local_data_source.dart';
import '../../features/home/data/repo/home_repo_impl.dart';
import '../../features/home/domain/repo/home_repo.dart';
import '../../features/home/presentation/manager/home_cubit/home_cubit.dart';

// --- Browse ---
import '../../features/browse/data/data_sources/browse_local_data_source.dart';
import '../../features/browse/data/repo/browse_repo_impl.dart';
import '../../features/browse/domain/repo/browse_repo.dart';
import '../../features/browse/presentation/manager/browse_cubit/browse_cubit.dart';

// --- Model Detail ---
import '../../features/model_detail/data/data_sources/model_detail_local_data_source.dart';
import '../../features/model_detail/data/repo/model_detail_repo_impl.dart';
import '../../features/model_detail/domain/repo/model_detail_repo.dart';

// --- Collections ---
import '../../features/collections/data/data_sources/collections_local_data_source.dart';
import '../../features/collections/data/repo/collections_repo_impl.dart';
import '../../features/collections/domain/repo/collections_repo.dart';
import '../../features/collections/presentation/manager/collections_cubit/collections_cubit.dart';

// --- Profile ---
import '../../features/profile/data/data_sources/profile_local_data_source.dart';
import '../../features/profile/data/repo/profile_repo_impl.dart';
import '../../features/profile/domain/repo/profile_repo.dart';
import '../../features/profile/presentation/manager/profile_cubit/profile_cubit.dart';

// --- Upload ---
import '../../features/upload/data/repo/upload_repo_impl.dart';
import '../../features/upload/domain/repo/upload_repo.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ─── Core / Storage ───────────────────────────────────────────────────────
  final hiveStorage = await HiveLocalStorage.init();
  sl.registerSingleton<LocalStorage>(hiveStorage);

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(storage: sl<LocalStorage>()),
  );

  // ─── Network ──────────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(localDataSource: sl<AuthLocalDataSource>()),
  );
  sl.registerLazySingleton<ErrorInterceptor>(() => ErrorInterceptor());
  sl.registerLazySingleton<LogInterseptor>(() => LogInterseptor());

  sl.registerLazySingleton<DioClient>(
    () => DioClient(
      baseUrl: NetworkConfig.physicalBaseUrl,
      authInterceptor: sl<AuthInterceptor>(),
      errorInterceptor: sl<ErrorInterceptor>(),
      logInterceptor: sl<LogInterseptor>(),
    ),
  );

  sl.registerLazySingleton<ApiService>(() => ApiService(sl<DioClient>().dio));

  // ─── Auth ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );

  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(
      authRemoteDataSource: sl<AuthRemoteDataSource>(),
      authLocalDataSource: sl<AuthLocalDataSource>(),
    ),
  );

  sl.registerFactory<LoginCubit>(() => LoginCubit(sl<AuthRepo>()));
  sl.registerFactory<SignUpCubit>(() => SignUpCubit(sl<AuthRepo>()));

  // ─── Home ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<HomeRepo>(
    () => HomeRepoImpl(sl<HomeLocalDataSource>()),
  );

  sl.registerFactory<HomeCubit>(() => HomeCubit(sl<HomeRepo>()));

  // ─── Browse ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton<BrowseLocalDataSource>(
    () => BrowseLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<BrowseRepo>(
    () => BrowseRepoImpl(sl<BrowseLocalDataSource>()),
  );

  sl.registerFactory<BrowseCubit>(() => BrowseCubit(sl<BrowseRepo>()));

  // ─── Model Detail ─────────────────────────────────────────────────────────
  // sl.registerLazySingleton<ModelDetailLocalDataSource>(
  //   () => ModelDetailLocalDataSourceImpl(),
  // );

  // sl.registerLazySingleton<ModelDetailRepo>(
  //   () => ModelDetailRepoImpl(sl<ModelDetailLocalDataSource>()),
  // );

  // ─── Collections ──────────────────────────────────────────────────────────
  sl.registerLazySingleton<CollectionsLocalDataSource>(
    () => CollectionsLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<CollectionsRepo>(
    () => CollectionsRepoImpl(sl<CollectionsLocalDataSource>()),
  );

  sl.registerFactory<CollectionsCubit>(
    () => CollectionsCubit(sl<CollectionsRepo>()),
  );

  // ─── Profile ──────────────────────────────────────────────────────────────
  sl.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<ProfileRepo>(
    () => ProfileRepoImpl(sl<ProfileLocalDataSource>()),
  );

  sl.registerFactory<ProfileCubit>(() => ProfileCubit(sl<ProfileRepo>()));

  // ─── Upload ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton<UploadLocalDataSource>(
    () => UploadLocalDataSource(),
  );

  sl.registerLazySingleton<UploadRepo>(
    () => UploadRepoImpl(sl<UploadLocalDataSource>()),
  );
}
