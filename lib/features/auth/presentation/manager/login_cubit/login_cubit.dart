import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repo/auth_repo.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepo) : super(const LoginInitial());

  final AuthRepo _authRepo;

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(const LoginLoading());

    final result = await _authRepo.signIn(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => emit(LoginFailureState(failure.message)),
      (token) => emit(LoginSuccess(token)),
    );
  }
}
