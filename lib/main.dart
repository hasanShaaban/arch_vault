import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/router/app_router.dart';
import 'core/router/go_router_refresh_stream.dart';
import 'core/storage/local_storage.dart';
import 'core/theme/app_theme.dart';
import 'features/admin/data/datasources/admin_local_datasource.dart';
import 'features/admin/data/repositories/admin_repo_impl.dart';
import 'features/admin/domain/repositories/admin_repo.dart';
import 'features/auth/data/data_sources/auth_local_data_source.dart';
import 'features/auth/data/repo/auth_repo_impl.dart';
import 'features/auth/domain/repo/auth_repo.dart';
import 'features/auth/presentation/manager/auth_session_cubit/auth_session_cubit.dart';
import 'features/auth/presentation/manager/login_cubit/login_cubit.dart';
import 'features/auth/presentation/manager/signup_cubit/signup_cubit.dart';
import 'features/browse/data/data_sources/browse_local_data_source.dart';
import 'features/browse/data/repo/browse_repo_impl.dart';
import 'features/browse/domain/repo/browse_repo.dart';
import 'features/browse/presentation/manager/browse_cubit/browse_cubit.dart';
import 'features/collections/data/data_sources/collections_local_data_source.dart';
import 'features/collections/data/repo/collections_repo_impl.dart';
import 'features/collections/domain/repo/collections_repo.dart';
import 'features/collections/presentation/manager/collections_cubit/collections_cubit.dart';
import 'features/home/data/data_sources/home_local_data_source.dart';
import 'features/home/data/repo/home_repo_impl.dart';
import 'features/home/domain/repo/home_repo.dart';
import 'features/home/presentation/manager/home_cubit/home_cubit.dart';
import 'features/model_detail/data/data_sources/model_detail_local_data_source.dart';
import 'features/model_detail/data/repo/model_detail_repo_impl.dart';
import 'features/model_detail/domain/repo/model_detail_repo.dart';
import 'features/profile/data/data_sources/profile_local_data_source.dart';
import 'features/profile/data/repo/profile_repo_impl.dart';
import 'features/profile/domain/repo/profile_repo.dart';
import 'features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import 'features/upload/data/repo/upload_repo_impl.dart';
import 'features/upload/domain/repo/upload_repo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = InMemoryStorage();
  final authRepo = AuthRepoImpl(AuthLocalDataSourceImpl(storage));
  final homeRepo = HomeRepoImpl(HomeLocalDataSourceImpl());
  final browseRepo = BrowseRepoImpl(BrowseLocalDataSourceImpl());
  final modelDetailRepo =
      ModelDetailRepoImpl(ModelDetailLocalDataSourceImpl());
  final collectionsRepo =
      CollectionsRepoImpl(CollectionsLocalDataSourceImpl());
  final profileRepo = ProfileRepoImpl(ProfileLocalDataSourceImpl());
  final uploadRepo = UploadRepoImpl(UploadLocalDataSource());
  final adminRepo = AdminRepoImpl(AdminLocalDataSourceImpl());

  final authSessionCubit = AuthSessionCubit(authRepo);
  await authSessionCubit.restoreSession();

  runApp(
    ArchVaultApp(
      authRepo: authRepo,
      authSessionCubit: authSessionCubit,
      homeRepo: homeRepo,
      browseRepo: browseRepo,
      modelDetailRepo: modelDetailRepo,
      collectionsRepo: collectionsRepo,
      profileRepo: profileRepo,
      uploadRepo: uploadRepo,
      adminRepo: adminRepo,
    ),
  );
}

class ArchVaultApp extends StatefulWidget {
  const ArchVaultApp({
    super.key,
    required this.authRepo,
    required this.authSessionCubit,
    required this.homeRepo,
    required this.browseRepo,
    required this.modelDetailRepo,
    required this.collectionsRepo,
    required this.profileRepo,
    required this.uploadRepo,
    required this.adminRepo,
  });

  final AuthRepo authRepo;
  final AuthSessionCubit authSessionCubit;
  final HomeRepo homeRepo;
  final BrowseRepo browseRepo;
  final ModelDetailRepo modelDetailRepo;
  final CollectionsRepo collectionsRepo;
  final ProfileRepo profileRepo;
  final UploadRepo uploadRepo;
  final AdminRepo adminRepo;

  @override
  State<ArchVaultApp> createState() => _ArchVaultAppState();
}

class _ArchVaultAppState extends State<ArchVaultApp> {
  late final GoRouterRefreshStream _refreshListenable;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _refreshListenable =
        GoRouterRefreshStream(widget.authSessionCubit.stream);
    _router = AppRouter.create(
      widget.authSessionCubit,
      refreshListenable: _refreshListenable,
    );
  }

  @override
  void dispose() {
    _refreshListenable.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepo>.value(value: widget.authRepo),
        RepositoryProvider<HomeRepo>.value(value: widget.homeRepo),
        RepositoryProvider<BrowseRepo>.value(value: widget.browseRepo),
        RepositoryProvider<ModelDetailRepo>.value(
          value: widget.modelDetailRepo,
        ),
        RepositoryProvider<CollectionsRepo>.value(
          value: widget.collectionsRepo,
        ),
        RepositoryProvider<ProfileRepo>.value(value: widget.profileRepo),
        RepositoryProvider<UploadRepo>.value(value: widget.uploadRepo),
        RepositoryProvider<AdminRepo>.value(value: widget.adminRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthSessionCubit>.value(value: widget.authSessionCubit),
          BlocProvider(
            create: (context) => LoginCubit(context.read<AuthRepo>()),
          ),
          BlocProvider(
            create: (context) => SignUpCubit(context.read<AuthRepo>()),
          ),
          BlocProvider(
            create: (context) => HomeCubit(context.read<HomeRepo>()),
          ),
          BlocProvider(
            create: (context) => BrowseCubit(context.read<BrowseRepo>()),
          ),
          BlocProvider(
            create: (context) =>
                CollectionsCubit(context.read<CollectionsRepo>()),
          ),
          BlocProvider(
            create: (context) => ProfileCubit(context.read<ProfileRepo>()),
          ),
        ],
        child: MaterialApp.router(
          title: 'ArchVault',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          routerConfig: _router,
        ),
      ),
    );
  }
}
