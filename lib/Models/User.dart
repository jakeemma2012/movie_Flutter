import 'dart:convert';

import 'package:movieappprj/Models/ViewingHistory.dart';
import 'package:movieappprj/Services/VIewingHistoryREPO.dart';

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

  static ViewingHistory? viewingHistory;

  static User? get getUser => user;

  static bool get _isLogedIn => user != null;

  factory User.fromJson(Map<String, dynamic> json) {
    // print(json);
    return User(
      email: json['email'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      role: json['role'],
      name: json['name'],
      id: json['userId'],
    );
  }

  static setViewingHistory() {
    ViewingHistoryService.fetchFromServer();
  }

  static getUserId() {
    return user?.id ?? 0;
  }

  static getAccessToken() {
    return user?.accessToken ?? '';
  }

  static void setUser(User user) {
    User.user = user;
    setViewingHistory();
  }

  static void clearUser() {
    User.user = null;
  }
}
