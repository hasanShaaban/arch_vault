import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_routes.dart';
import '../../features/auth/domain/repo/auth_repo.dart';
import '../../features/auth/presentation/manager/auth_session_cubit/auth_session_cubit.dart';
import '../../features/auth/presentation/manager/auth_session_cubit/auth_session_state.dart';
import '../../features/auth/presentation/manager/forgot_password_cubit/forgot_password_cubit.dart';
import '../../features/auth/presentation/views/forgot_password_view.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/auth/presentation/views/signup_view.dart';
import '../../features/browse/presentation/views/browse_view.dart';
import '../../features/collections/domain/repo/collections_repo.dart';
import '../../features/collections/presentation/manager/collection_detail_cubit/collection_detail_cubit.dart';
import '../../features/collections/presentation/views/collection_detail_view.dart';
import '../../features/collections/presentation/views/collections_view.dart';
import '../../features/home/presentation/views/home_view.dart';
import '../../features/model_detail/domain/repo/model_detail_repo.dart';
import '../../features/model_detail/presentation/manager/model_detail_cubit/model_detail_cubit.dart';
import '../../features/model_detail/presentation/views/model_detail_view.dart';
import '../../features/profile/presentation/views/profile_view.dart';
import '../../features/upload/domain/repo/upload_repo.dart';
import '../../features/upload/presentation/manager/my_uploads_cubit/my_uploads_cubit.dart';
import '../../features/upload/presentation/manager/upload_cubit/upload_cubit.dart';
import '../../features/upload/presentation/views/my_uploads_view.dart';
import '../../features/upload/presentation/views/upload_view.dart';

class AppRouter {
  AppRouter._();

  static const _authLocations = {
    AppRoutes.signIn,
    AppRoutes.signUp,
    AppRoutes.forgotPassword,
  };

  static GoRouter create(
    AuthSessionCubit sessionCubit, {
    required Listenable refreshListenable,
  }) {
    return GoRouter(
      initialLocation: AppRoutes.signIn,
      refreshListenable: refreshListenable,
      redirect: (context, state) {
        final session = sessionCubit.state;
        if (session is AuthSessionUnknown) return null;

        final loggedIn = session is AuthSessionAuthenticated;
        final onAuth = _authLocations.contains(state.matchedLocation);

        if (!loggedIn && !onAuth) return AppRoutes.signIn;
        if (loggedIn && onAuth) return AppRoutes.home;
        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.signIn,
          builder: (context, state) => const LoginView(),
        ),
        GoRoute(
          path: AppRoutes.signUp,
          builder: (context, state) => const SignUpView(),
        ),
        GoRoute(
          path: AppRoutes.forgotPassword,
          builder: (context, state) {
            return BlocProvider(
              create: (context) =>
                  ForgotPasswordCubit(context.read<AuthRepo>()),
              child: const ForgotPasswordView(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const HomeView(),
        ),
        GoRoute(
          path: AppRoutes.browse,
          builder: (context, state) => const BrowseView(),
        ),
        GoRoute(
          path: AppRoutes.collections,
          builder: (context, state) => const CollectionsView(),
        ),
        GoRoute(
          path: AppRoutes.collectionDetail,
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            return BlocProvider(
              create: (context) =>
                  CollectionDetailCubit(context.read<CollectionsRepo>())
                    ..load(id),
              child: CollectionDetailView(collectionId: id),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => const ProfileView(),
        ),
        GoRoute(
          path: AppRoutes.upload,
          builder: (context, state) {
            return BlocProvider(
              create: (context) => UploadCubit(context.read<UploadRepo>()),
              child: const UploadView(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.uploads,
          builder: (context, state) {
            return BlocProvider(
              create: (context) => MyUploadsCubit(context.read<UploadRepo>()),
              child: const MyUploadsView(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.modelDetail,
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            return BlocProvider(
              create: (context) =>
                  ModelDetailCubit(context.read<ModelDetailRepo>())..load(id),
              child: ModelDetailView(modelId: id),
            );
          },
        ),
      ],
    );
  }
}
