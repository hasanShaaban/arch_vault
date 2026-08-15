import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repo/auth_repo.dart';
import 'signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authRepo) : super(const SignUpInitial());

  final AuthRepo _authRepo;

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
    required String confirmPassword,
    required String role,
  }) async {
    emit(const SignUpLoading());
    final result = await _authRepo.signUp(
      email: email,
      password: password,
      username: username,
      confirmPassword: confirmPassword,
      role: role,
    );
    result.fold(
      (failure) => emit(SignUpFailureState(failure.message)),
      (response) => emit(SignUpSuccess(response)),
    );
  }
}
