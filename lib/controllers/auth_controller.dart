import 'package:flutter_app/controllers/photo_controller.dart';
import 'package:flutter_app/model/photo.dart';
import 'package:flutter_app/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AuthController {
  final User user = User();
  final SharedPreferences prefs;
  late PhotoController _photoController;

  AuthController(this.prefs) {
    _photoController = PhotoController();
  }

  Future<void> setUserId(String userId) async {
    await prefs.setString('userId', userId);
  }

  Future<String?> getUserId() async {
    return prefs.getString('userId');
  }

  Future<void> clearUserId() async {
    await prefs.remove('userId');
  }

  Future<void> signUp(String username, String password) async {
    const uuid = Uuid();
    final userId = uuid.v4();
    await prefs.setString('userId', userId);
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  //not using
  User? getUserData() {
    final username = prefs.getString('username');
    final password = prefs.getString('password');
    if (username != null && password != null) {
      return User(username: username, password: password);
    }
    return null;
  }

  //not using
  Future<void> updateUser(String username, String newPassword) async {
    await prefs.setString('username', username);
    await prefs.setString('password', newPassword);
  }

  //not using
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

  // auth_controller.dart
  Future<void> savePhoto(Photo photo) async {
    final userId = await getUserId();
    if (userId != null) {
      await _photoController.savePhoto(photo, userId);
    }
  }
}
