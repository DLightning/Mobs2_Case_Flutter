import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/auth_controller.dart';

class HomeScreen extends StatelessWidget {
  final AuthController authController;

  HomeScreen(this.authController);

  void _logOut(BuildContext context) async {
    await authController.logout();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your home screen content
            ElevatedButton(
              onPressed: () => _logOut(context), // Pass the context
              child: Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
