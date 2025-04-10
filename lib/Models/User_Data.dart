import 'User.dart';

class User {
  final String name;
  final String email;
  final String accsessToken;
  final String refreshToken;
  final String role;

  User(this.name, this.email,this.accsessToken,this.refreshToken,this.role);
}


class UserData {
  static User? user;

  UserData() {
    // Constructor no longer initializes static field
  }

  static User? get getUser => user;

  static bool get _isLogedIn => user != null;



}