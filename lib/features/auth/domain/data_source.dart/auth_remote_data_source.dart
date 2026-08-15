import 'package:arch_vault/features/auth/domain/entities/auth_token_entity.dart';
import 'package:arch_vault/features/auth/domain/entities/sign_up_response_entity.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokenEntity> signIn({
    required String email,
    required String password,
  });

  Future<SignUpResponseEntity> signUp({
    required String email,
    required String password,
    required String confirmPassword,
    required String username,
    required String role,
  });

  // Future<UserModel?> getCurrentUser();

  // Future<void> signOut();

  // Future<void> requestPasswordReset({required String email});
}
