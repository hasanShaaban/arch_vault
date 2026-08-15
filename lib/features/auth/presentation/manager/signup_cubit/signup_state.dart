import 'package:arch_vault/features/auth/domain/entities/sign_up_response_entity.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_entity.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object?> get props => [];
}

class SignUpInitial extends SignUpState {
  const SignUpInitial();
}

class SignUpLoading extends SignUpState {
  const SignUpLoading();
}

class SignUpSuccess extends SignUpState {
  const SignUpSuccess(this.signUpResponseEntity);

  final SignUpResponseEntity signUpResponseEntity;

  @override
  List<Object?> get props => [
    signUpResponseEntity.email,
    signUpResponseEntity.username,
    signUpResponseEntity.role,
  ];
}

class SignUpFailureState extends SignUpState {
  const SignUpFailureState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
