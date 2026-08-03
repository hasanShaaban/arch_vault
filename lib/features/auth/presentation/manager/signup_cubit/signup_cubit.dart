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
  }) async {
    emit(const SignUpLoading());
    try {
      final user = await _authRepo.signUp(
        email: email,
        password: password,
        username: username,
      );
      emit(SignUpSuccess(user));
    } catch (e) {
      emit(SignUpFailureState(e.toString()));
    }
  }
}
