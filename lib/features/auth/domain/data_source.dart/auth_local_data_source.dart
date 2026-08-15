/// Abstract contract for auth-specific local storage operations.
///
/// Implementations are responsible for persisting and retrieving
/// authentication tokens using whatever storage mechanism is provided.
abstract class AuthLocalDataSource {
  /// Persists [accessToken] and [refreshToken] locally.
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });

  /// Returns the stored access token, or `null` if none is saved.
  Future<String?> getAccessToken();

  /// Returns the stored refresh token, or `null` if none is saved.
  Future<String?> getRefreshToken();

  /// Removes both tokens from local storage (e.g. on sign-out).
  Future<void> clearTokens();
}
