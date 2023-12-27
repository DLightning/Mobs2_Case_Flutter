import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/auth_controller.dart';
import 'package:flutter_app/screens/photo_screen.dart';
import 'package:flutter_app/controllers/photo_controller.dart';
import 'package:flutter_app/model/photo.dart';
import 'package:flutter_app/screens/userphoto_screen.dart';

class HomeScreen extends StatefulWidget {
  final AuthController authController;

  const HomeScreen(this.authController, {Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = widget.authController;
  }

  void _logOut(BuildContext context) async {
    await _authController.logout();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _logOut(context),
              child: const Text('Log Out'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PhotoCaptureView()),
                );
              },
              child: const Text('Go to PhotoCaptureView'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          UserPhotosScreen(authController: _authController)),
                );
              },
              child: const Text('View User Photos'),
            ),
          ],
        ),
      ),
    );
  }
}
