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
  const SignUpSuccess(this.user);

  final UserEntity user;

  @override
  List<Object?> get props => [user.id, user.email];
}

class SignUpFailureState extends SignUpState {
  const SignUpFailureState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
