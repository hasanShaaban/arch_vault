import '../../domain/entities/sign_up_response_entity.dart';

class SignUpResponseModel extends SignUpResponseEntity {
  const SignUpResponseModel({
    required super.email,
    required super.username,
    required super.role,
  });

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) =>
      SignUpResponseModel(
        email: json['email'] as String,
        username: json['username'] as String,
        role: json['role'] as String,
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'username': username,
        'role': role,
      };
}
