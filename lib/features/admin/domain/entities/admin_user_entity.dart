class AdminUserEntity {
  const AdminUserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.modelsCount,
  });

  final String id;
  final String username;
  final String email;

  /// `user` or `admin`.
  final String role;
  final int modelsCount;

  bool get isAdmin => role == 'admin';
}
