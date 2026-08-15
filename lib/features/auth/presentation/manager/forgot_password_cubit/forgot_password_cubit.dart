// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../domain/repo/auth_repo.dart';
// import 'forgot_password_state.dart';

// class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
//   ForgotPasswordCubit(this._authRepo) : super(const ForgotPasswordInitial());

//   final AuthRepo _authRepo;

//   Future<void> submit({required String email}) async {
//     emit(const ForgotPasswordLoading());
//     try {
//       await _authRepo.requestPasswordReset(email: email);
//       emit(ForgotPasswordSuccess(email.trim()));
//     } catch (e) {
//       emit(ForgotPasswordFailureState(e.toString()));
//     }
//   }
// }
