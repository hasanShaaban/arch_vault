import '../../domain/entities/auth_token_entity.dart';

class AuthTokenModel extends AuthTokenEntity {
  const AuthTokenModel({
    required super.refresh,
    required super.access,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) => AuthTokenModel(
        refresh: json['refresh'] as String,
        access: json['access'] as String,
      );

  Map<String, dynamic> toJson() => {
        'refresh': refresh,
        'access': access,
      };
}
