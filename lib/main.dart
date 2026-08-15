import 'package:arch_vault/core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/domain/repo/auth_repo.dart';
import 'features/auth/presentation/manager/login_cubit/login_cubit.dart';
import 'features/auth/presentation/manager/signup_cubit/signup_cubit.dart';
import 'features/browse/domain/repo/browse_repo.dart';
import 'features/browse/presentation/manager/browse_cubit/browse_cubit.dart';
import 'features/collections/domain/repo/collections_repo.dart';
import 'features/collections/presentation/manager/collections_cubit/collections_cubit.dart';
import 'features/home/domain/repo/home_repo.dart';
import 'features/home/presentation/manager/home_cubit/home_cubit.dart';
import 'features/profile/domain/repo/profile_repo.dart';
import 'features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import 'features/upload/domain/repo/upload_repo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const ArchVaultApp());
}

class ArchVaultApp extends StatefulWidget {
  const ArchVaultApp({super.key});
  @override
  State<ArchVaultApp> createState() => _ArchVaultAppState();
}

class _ArchVaultAppState extends State<ArchVaultApp> {
  late final GoRouter _router;
  @override
  void initState() {
    super.initState();
    _router = AppRouter.create();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepo>.value(value: sl<AuthRepo>()),
        RepositoryProvider<HomeRepo>.value(value: sl<HomeRepo>()),
        RepositoryProvider<BrowseRepo>.value(value: sl<BrowseRepo>()),
        // RepositoryProvider<ModelDetailRepo>.value(value: sl<ModelDetailRepo>()),
        RepositoryProvider<CollectionsRepo>.value(value: sl<CollectionsRepo>()),
        RepositoryProvider<ProfileRepo>.value(value: sl<ProfileRepo>()),
        RepositoryProvider<UploadRepo>.value(value: sl<UploadRepo>()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LoginCubit>(create: (_) => sl<LoginCubit>()),
          BlocProvider<SignUpCubit>(create: (_) => sl<SignUpCubit>()),
          BlocProvider<HomeCubit>(create: (_) => sl<HomeCubit>()),
          BlocProvider<BrowseCubit>(create: (_) => sl<BrowseCubit>()),
          BlocProvider<CollectionsCubit>(create: (_) => sl<CollectionsCubit>()),
          BlocProvider<ProfileCubit>(create: (_) => sl<ProfileCubit>()),
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
