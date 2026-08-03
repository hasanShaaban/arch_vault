import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({
    required String email,
    required String password,
  });

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String username,
  });

  Future<UserModel?> getCurrentUser();

  Future<void> signOut();

  Future<void> requestPasswordReset({required String email});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  Never _notReady() =>
      throw UnimplementedError('Auth remote API is not connected yet.');

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async =>
      _notReady();

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String username,
  }) async =>
      _notReady();

  @override
  Future<UserModel?> getCurrentUser() async => _notReady();

  @override
  Future<void> signOut() async => _notReady();

  @override
  Future<void> requestPasswordReset({required String email}) async =>
      _notReady();
}
