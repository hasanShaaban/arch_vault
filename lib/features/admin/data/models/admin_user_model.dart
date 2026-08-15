import '../../domain/entities/admin_user_entity.dart';

class AdminUserModel {
  const AdminUserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.modelsCount,
  });

  final String id;
  final String username;
  final String email;
  final String role;
  final int modelsCount;

  AdminUserModel copyWith({String? role}) {
    return AdminUserModel(
      id: id,
      username: username,
      email: email,
      role: role ?? this.role,
      modelsCount: modelsCount,
    );
  }

  AdminUserEntity toEntity() => AdminUserEntity(
        id: id,
        username: username,
        email: email,
        role: role,
        modelsCount: modelsCount,
      );
}
