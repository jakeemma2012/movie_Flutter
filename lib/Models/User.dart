import 'dart:convert';

class User {
  final int id;
  final String name;
  final String email;
  final String accessToken;
  final String refreshToken;
  final String role;

  User({
    required this.id,
    required this.accessToken,
    required this.refreshToken,
    required this.role,
    required this.name,
    required this.email,
  });

  static User? user;

  static User? get getUser => user;

  static bool get _isLogedIn => user != null;

  factory User.fromJson(Map<String, dynamic> json) {
    print(json);
    return User(
      email: json['email'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      role: json['role'],
      name: json['name'],
      id: json['userId'],
    );
  }

  static getUserId() {
    return user?.id ?? 0;
  }
}
