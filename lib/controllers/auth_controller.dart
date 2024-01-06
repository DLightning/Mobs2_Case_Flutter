import 'package:flutter_app/controllers/photo_controller.dart';
import 'package:flutter_app/model/photo.dart';
import 'package:flutter_app/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AuthController {
  final SharedPreferences prefs;
  late PhotoController _photoController;

  AuthController(this.prefs) {
    _photoController = PhotoController();
  }

  Future<void> addUser(String username, String password) async {
    final userList = prefs.getStringList('userList') ?? [];
    final uuid = Uuid();
    final userId = uuid.v4();
    userList.add(userId);

    await prefs.setStringList('userList', userList);
    await prefs.setString('userId_$userId', userId);
    await prefs.setString('username_$userId', username);
    await prefs.setString('password_$userId', password);
  }

  Future<void> setUserId(String userId) async {
    await prefs.setString('currentUserId', userId);
  }

  Future<String?> getUserId() async {
    return prefs.getString('currentUserId');
  }

  Future<void> clearUserId() async {
    await prefs.remove('currentUserId');
  }

  Future<bool> login(String username, String password) async {
    final userList = prefs.getStringList('userList') ?? [];

    for (final userId in userList) {
      final storedUsername = prefs.getString('username_$userId');
      final storedPassword = prefs.getString('password_$userId');

      if (storedUsername == username && storedPassword == password) {
        await setUserId(userId);
        return true;
      }
    }

    return false;
  }

  bool isLoggedIn() {
    final currentUserId = prefs.getString('currentUserId');
    return currentUserId != null;
  }

  Future<void> logout() async {
    await clearUserId();
  }

  Future<void> signUp(String username, String password) async {
    final userList = prefs.getStringList('userList') ?? [];
    final uuid = Uuid();
    final userId = uuid.v4();
    userList.add(userId);

    await prefs.setStringList('userList', userList);
    await prefs.setString('username_$userId', username);
    await prefs.setString('password_$userId', password);
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

  Future<void> deleteUser() async {
    await prefs.remove('username');
    await prefs.remove('password');
  }

  // auth_controller.dart
  Future<void> savePhoto(Photo photo) async {
    final userId = await getUserId();
    if (userId != null) {
      await _photoController.savePhoto(photo, userId);
    }
  }
}
