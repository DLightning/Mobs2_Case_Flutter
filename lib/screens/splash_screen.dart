import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  final AuthController authController;

  const SplashScreen(this.authController, {super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      checkLoginAndNavigate(context);
    });
  }

  Future<void> checkLoginAndNavigate(BuildContext context) async {
    final isLoggedIn = widget.authController.isLoggedIn();
    print(isLoggedIn.toString());

    if (isLoggedIn) {
      print(isLoggedIn.toString());
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
