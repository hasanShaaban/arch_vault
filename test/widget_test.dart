import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:arch_vault/core/storage/local_storage.dart';
import 'package:arch_vault/core/theme/app_theme.dart';
import 'package:arch_vault/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:arch_vault/features/auth/data/repo/auth_repo_impl.dart';
import 'package:arch_vault/features/auth/presentation/manager/auth_session_cubit/auth_session_cubit.dart';
import 'package:arch_vault/features/browse/data/data_sources/browse_local_data_source.dart';
import 'package:arch_vault/features/browse/data/repo/browse_repo_impl.dart';
import 'package:arch_vault/features/browse/domain/repo/browse_repo.dart';
import 'package:arch_vault/features/browse/presentation/manager/browse_cubit/browse_cubit.dart';
import 'package:arch_vault/features/browse/presentation/views/browse_view.dart';
import 'package:arch_vault/features/collections/data/data_sources/collections_local_data_source.dart';
import 'package:arch_vault/features/collections/data/repo/collections_repo_impl.dart';
import 'package:arch_vault/features/collections/domain/repo/collections_repo.dart';
import 'package:arch_vault/features/collections/presentation/manager/collections_cubit/collections_cubit.dart';
import 'package:arch_vault/features/collections/presentation/views/collections_view.dart';
import 'package:arch_vault/features/home/data/data_sources/home_local_data_source.dart';
import 'package:arch_vault/features/home/data/repo/home_repo_impl.dart';
import 'package:arch_vault/features/home/domain/repo/home_repo.dart';
import 'package:arch_vault/features/home/presentation/manager/home_cubit/home_cubit.dart';
import 'package:arch_vault/features/home/presentation/views/home_view.dart';
import 'package:arch_vault/features/model_detail/data/data_sources/model_detail_local_data_source.dart';
import 'package:arch_vault/features/model_detail/data/repo/model_detail_repo_impl.dart';
import 'package:arch_vault/features/model_detail/domain/repo/model_detail_repo.dart';
import 'package:arch_vault/features/model_detail/presentation/manager/model_detail_cubit/model_detail_cubit.dart';
import 'package:arch_vault/features/model_detail/presentation/views/model_detail_view.dart';
import 'package:arch_vault/features/profile/data/data_sources/profile_local_data_source.dart';
import 'package:arch_vault/features/profile/data/repo/profile_repo_impl.dart';
import 'package:arch_vault/features/profile/domain/repo/profile_repo.dart';
import 'package:arch_vault/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:arch_vault/features/profile/presentation/views/profile_view.dart';
import 'package:arch_vault/features/upload/data/repo/upload_repo_impl.dart';
import 'package:arch_vault/main.dart';

void main() {
  Future<ArchVaultApp> buildApp() async {
    final authRepo = AuthRepoImpl(AuthLocalDataSourceImpl(InMemoryStorage()));
    final authSessionCubit = AuthSessionCubit(authRepo);
    await authSessionCubit.restoreSession();
    return ArchVaultApp(
      authRepo: authRepo,
      authSessionCubit: authSessionCubit,
      homeRepo: HomeRepoImpl(HomeLocalDataSourceImpl()),
      browseRepo: BrowseRepoImpl(BrowseLocalDataSourceImpl()),
      modelDetailRepo:
          ModelDetailRepoImpl(ModelDetailLocalDataSourceImpl()),
      collectionsRepo:
          CollectionsRepoImpl(CollectionsLocalDataSourceImpl()),
      profileRepo: ProfileRepoImpl(ProfileLocalDataSourceImpl()),
      uploadRepo: UploadRepoImpl(UploadLocalDataSource()),
    );
  }

  testWidgets('Sign In screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(await buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('Create Account screen renders from Sign In link', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(await buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();

    expect(find.text('Create Account'), findsOneWidget);
  });

  testWidgets('Home screen loads featured models', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1280, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final homeRepo = HomeRepoImpl(HomeLocalDataSourceImpl());
    await tester.pumpWidget(
      RepositoryProvider<HomeRepo>.value(
        value: homeRepo,
        child: BlocProvider(
          create: (_) => HomeCubit(homeRepo),
          child: MaterialApp(
            theme: AppTheme.dark,
            home: const HomeView(),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.text('Featured models'), findsOneWidget);
    expect(find.text('Modern Villa Atrium'), findsOneWidget);
  });

  testWidgets('Browse screen loads assets and filters', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1280, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final browseRepo = BrowseRepoImpl(BrowseLocalDataSourceImpl());
    await tester.pumpWidget(
      RepositoryProvider<BrowseRepo>.value(
        value: browseRepo,
        child: BlocProvider(
          create: (_) => BrowseCubit(browseRepo),
          child: MaterialApp(
            theme: AppTheme.dark,
            home: const BrowseView(),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.text('Browse Assets'), findsOneWidget);
    expect(find.text('Cultural Pavilion'), findsOneWidget);

    await tester.tap(find.text('Residential').first);
    await tester.pumpAndSettle();
    expect(find.text('Modern Villa Atrium'), findsOneWidget);
    expect(find.text('Cultural Pavilion'), findsNothing);
  });

  testWidgets('Model detail screen shows description and similar models', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1280, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final repo = ModelDetailRepoImpl(ModelDetailLocalDataSourceImpl());
    await tester.pumpWidget(
      RepositoryProvider<ModelDetailRepo>.value(
        value: repo,
        child: BlocProvider(
          create: (_) => ModelDetailCubit(repo)..load('1'),
          child: MaterialApp(
            theme: AppTheme.dark,
            home: const ModelDetailView(modelId: '1'),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('Modern Villa Atrium'), findsWidgets);
    expect(find.text('Description'), findsOneWidget);
    expect(find.textContaining('contemporary villa'), findsOneWidget);
    expect(find.text('Similar models'), findsOneWidget);
    expect(find.text('Courtyard Residence'), findsOneWidget);
  });

  testWidgets('Collections screen loads collection cards', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1280, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final repo = CollectionsRepoImpl(CollectionsLocalDataSourceImpl());
    await tester.pumpWidget(
      RepositoryProvider<CollectionsRepo>.value(
        value: repo,
        child: BlocProvider(
          create: (_) => CollectionsCubit(repo),
          child: MaterialApp(
            theme: AppTheme.dark,
            home: const CollectionsView(),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.text('My Collections'), findsOneWidget);
    expect(find.text('Residential Favorites'), findsOneWidget);
    expect(find.text('Commercial Towers'), findsOneWidget);
  });

  testWidgets('Profile screen shows stats and tabs', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1280, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final repo = ProfileRepoImpl(ProfileLocalDataSourceImpl());
    final authRepo = AuthRepoImpl(AuthLocalDataSourceImpl(InMemoryStorage()));
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<ProfileRepo>.value(value: repo),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => ProfileCubit(repo)),
            BlocProvider(create: (_) => AuthSessionCubit(authRepo)),
          ],
          child: MaterialApp(
            theme: AppTheme.dark,
            home: const ProfileView(),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.text('Studio Arch'), findsOneWidget);
    expect(find.text('@studio_arch'), findsOneWidget);
    expect(find.text('All Assets'), findsOneWidget);
    expect(find.text('Modern Villa Atrium'), findsOneWidget);
    expect(find.text('Log out'), findsOneWidget);

    await tester.tap(find.text('Popular'));
    await tester.pumpAndSettle();
    expect(find.text('Modern Villa Atrium'), findsOneWidget);
    expect(find.text('Skyline Lobby'), findsNothing);
  });
}
