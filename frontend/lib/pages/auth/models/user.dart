class AuthUser {
  final int id;
  final String name;
  final String username;
  final String email;

  const AuthUser({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json['id'] as int,
        name: json['name'] as String,
        username: json['username'] as String,
        email: json['email'] as String,
      );
}
