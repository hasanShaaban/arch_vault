class AuthTokenEntity {
  const AuthTokenEntity({
    required this.refresh,
    required this.access,
  });

  final String refresh;
  final String access;
}
