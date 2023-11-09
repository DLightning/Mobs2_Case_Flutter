import 'package:flutter_app/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final User user = User();
  final SharedPreferences prefs;

  AuthController(this.prefs);

  Future<void> signUp(String username, String password) async {
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  User? getUserData() {
    final username = prefs.getString('username');
    final password = prefs.getString('password');
    if (username != null && password != null) {
      return User(username: username, password: password);
    }
    return null;
  }

  Future<void> updateUser(String username, String newPassword) async {
    await prefs.setString('username', username);
    await prefs.setString('password', newPassword);
  }

  Future<void> deleteUser() async {
    await prefs.remove('username');
    await prefs.remove('password');
  }

  Future<bool> login(String username, String password) async {
    final storedUsername = prefs.getString('username');
    final storedPassword = prefs.getString('password');

    if (storedUsername == username && storedPassword == password) {
      await prefs.setBool('isLoggedIn', true);
      return true;
    } else {
      return false;
    }
  }

  bool isLoggedIn() {
    final storedUsername = prefs.getString('username');
    final storedPassword = prefs.getString('password');
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    return isLoggedIn && storedUsername != null && storedPassword != null;
  }

  Future<void> logout() async {
    await prefs.setBool('isLoggedIn', false);
  }
}
