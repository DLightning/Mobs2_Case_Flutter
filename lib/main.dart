import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/auth_controller.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:flutter_app/screens/login_screen.dart';
import 'package:flutter_app/screens/photo_screen.dart';
import 'package:flutter_app/screens/signup_screen.dart';
import 'package:flutter_app/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final authController = AuthController(prefs);
  final isUserLoggedIn = authController.isLoggedIn();

  runApp(MyApp(
    authController: authController,
    isUserLoggedIn: isUserLoggedIn,
  ));
}

class MyApp extends StatelessWidget {
  final AuthController authController;

  const MyApp(
      {super.key, required this.authController, required bool isUserLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(authController),
        '/login': (context) => LoginScreen(authController: authController),
        '/signup': (context) => SignupScreen(authController),
        '/home': (context) => HomeScreen(authController),
        '/photo': (context) => PhotoCaptureView(),
      },
    );
  }
}
