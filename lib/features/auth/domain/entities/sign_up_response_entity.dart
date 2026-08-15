class SignUpResponseEntity {
  const SignUpResponseEntity({
    required this.email,
    required this.username,
    required this.role,
  });

  final String email;
  final String username;
  final String role;
}
