import 'package:arch_vault/core/storage/local_storage.dart';
import 'package:arch_vault/core/storage/storage_keys.dart';
import 'package:arch_vault/features/auth/domain/data_source.dart/auth_local_data_source.dart';

/// [AuthLocalDataSource] implementation that delegates persistence to the
/// injected [LocalStorage] instance (Hive in production).
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl({required LocalStorage storage})
      : _storage = storage;

  final LocalStorage _storage;

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(StorageKeys.accessToken, accessToken),
      _storage.write(StorageKeys.refreshToken, refreshToken),
    ]);
  }

  @override
  Future<String?> getAccessToken() => _storage.read(StorageKeys.accessToken);

  @override
  Future<String?> getRefreshToken() => _storage.read(StorageKeys.refreshToken);

  @override
  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(StorageKeys.accessToken),
      _storage.delete(StorageKeys.refreshToken),
    ]);
  }
}
