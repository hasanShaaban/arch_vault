import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_entity.dart';

sealed class AuthSessionState extends Equatable {
  const AuthSessionState();

  @override
  List<Object?> get props => [];
}

class AuthSessionUnknown extends AuthSessionState {
  const AuthSessionUnknown();
}

class AuthSessionUnauthenticated extends AuthSessionState {
  const AuthSessionUnauthenticated();
}

class AuthSessionAuthenticated extends AuthSessionState {
  const AuthSessionAuthenticated(this.user);

  final UserEntity user;

  @override
  List<Object?> get props => [user.id, user.email, user.username];
}
