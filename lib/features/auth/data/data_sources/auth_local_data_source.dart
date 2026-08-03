import '../../../../core/errors/failures.dart';
import '../../../../core/storage/local_storage.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
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

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._storage);

  static const _sessionKey = 'auth_session_user';

  final LocalStorage _storage;

  final Map<String, String> _passwords = {
    'demo@archvault.com': 'password123',
  };

  final Map<String, UserModel> _users = {
    'demo@archvault.com': const UserModel(
      id: '1',
      email: 'demo@archvault.com',
      username: 'studio_arch',
    ),
  };

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final key = email.trim().toLowerCase();
    final stored = _passwords[key];
    if (stored == null || stored != password) {
      throw const AuthFailure('Invalid email or password');
    }
    final user = _users[key]!;
    await _storage.write(_sessionKey, user.email);
    return user;
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final key = email.trim().toLowerCase();
    if (_users.containsKey(key)) {
      throw const AuthFailure('An account with this email already exists');
    }
    if (password.length < 6) {
      throw const AuthFailure('Password must be at least 6 characters');
    }
    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: key,
      username: username.trim(),
    );
    _users[key] = user;
    _passwords[key] = password;
    await _storage.write(_sessionKey, user.email);
    return user;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final email = await _storage.read(_sessionKey);
    if (email == null || email.isEmpty) return null;
    return _users[email];
  }

  @override
  Future<void> signOut() async {
    await _storage.delete(_sessionKey);
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final key = email.trim().toLowerCase();
    if (key.isEmpty || !key.contains('@')) {
      throw const AuthFailure('Enter a valid email');
    }
  }
}
