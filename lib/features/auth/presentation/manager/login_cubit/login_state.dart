import 'package:equatable/equatable.dart';

import '../../../domain/entities/auth_token_entity.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  const LoginSuccess(this.token);

  final AuthTokenEntity token;

  @override
  List<Object?> get props => [token.access, token.refresh];
}

class LoginFailureState extends LoginState {
  const LoginFailureState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
