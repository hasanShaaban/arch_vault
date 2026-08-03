import '../entities/user_entity.dart';

abstract class AuthRepo {
  Future<UserEntity> signIn({
    required String email,
    required String password,
  });

  Future<UserEntity> signUp({
    required String email,
    required String password,
    required String username,
  });

  Future<UserEntity?> getCurrentUser();

  Future<void> signOut();

  /// Mock password-reset request. Backend will send the email later.
  Future<void> requestPasswordReset({required String email});
}
