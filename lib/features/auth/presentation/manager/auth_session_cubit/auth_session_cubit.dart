import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/repo/auth_repo.dart';
import 'auth_session_state.dart';

class AuthSessionCubit extends Cubit<AuthSessionState> {
  AuthSessionCubit(this._authRepo) : super(const AuthSessionUnknown());

  final AuthRepo _authRepo;

  Future<void> restoreSession() async {
    try {
      final user = await _authRepo.getCurrentUser();
      if (user == null) {
        emit(const AuthSessionUnauthenticated());
      } else {
        emit(AuthSessionAuthenticated(user));
      }
    } catch (_) {
      emit(const AuthSessionUnauthenticated());
    }
  }

  void onSignedIn(UserEntity user) {
    emit(AuthSessionAuthenticated(user));
  }

  Future<void> signOut() async {
    await _authRepo.signOut();
    emit(const AuthSessionUnauthenticated());
  }
}
