/// Centralised keys used when reading/writing values to [LocalStorage].
///
/// Keeping keys in one place prevents typos and makes it easy to audit
/// everything that is persisted locally.
class StorageKeys {
  StorageKeys._();

  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
}
