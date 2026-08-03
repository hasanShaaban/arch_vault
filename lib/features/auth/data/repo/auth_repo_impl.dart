import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repo/auth_repo.dart';
import '../data_sources/auth_local_data_source.dart';

class AuthRepoImpl implements AuthRepo {
  AuthRepoImpl(this._localDataSource);

  final AuthLocalDataSource _localDataSource;

  @override
  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final model = await _localDataSource.signIn(
        email: email,
        password: password,
      );
      return model.toEntity();
    } on Failure {
      rethrow;
    } catch (_) {
      throw const AuthFailure('Unexpected sign-in error');
    }
  }

  @override
  Future<UserEntity> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final model = await _localDataSource.signUp(
        email: email,
        password: password,
        username: username,
      );
      return model.toEntity();
    } on Failure {
      rethrow;
    } catch (_) {
      throw const AuthFailure('Unexpected sign-up error');
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final model = await _localDataSource.getCurrentUser();
      return model?.toEntity();
    } catch (_) {
      throw const AuthFailure('Unexpected session restore error');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _localDataSource.signOut();
    } catch (_) {
      throw const AuthFailure('Unexpected sign-out error');
    }
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {
    try {
      await _localDataSource.requestPasswordReset(email: email);
    } on Failure {
      rethrow;
    } catch (_) {
      throw const AuthFailure('Unexpected password reset error');
    }
  }
}
