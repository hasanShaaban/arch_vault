import '../../domain/entities/user_entity.dart';

class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    required this.username,
    this.role = 'user',
  });

  final String id;
  final String email;
  final String username;
  final String role;

  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        username: username,
        role: role,
      );
}
