import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/auth_controller.dart';
import 'package:flutter_app/controllers/photo_controller.dart';
import 'package:flutter_app/model/photo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPhotosScreen extends StatefulWidget {
  final AuthController? authController;

  UserPhotosScreen({Key? key, required this.authController}) : super(key: key);

  @override
  _UserPhotosScreenState createState() => _UserPhotosScreenState();
}

class _UserPhotosScreenState extends State<UserPhotosScreen> {
  final PhotoController _photoController = PhotoController();

  late AuthController _authController;
  late List<Photo> _userPhotos;

  @override
  void initState() {
    super.initState();

    _initializeAuthController();
    _loadUserPhotos();
  }

  Future<void> _initializeAuthController() async {
    final prefs = await SharedPreferences.getInstance();
    _authController = widget.authController ?? AuthController(prefs);
  }

  Future<void> _loadUserPhotos() async {
    String? userId = await _authController.getUserId();

    if (userId == null) {
      return;
    }
    _userPhotos = await _photoController.getUserPhotos(userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Photos')),
      body: _userPhotos.isEmpty
          ? Center(child: Text('No photos available.'))
          : ListView.builder(
              itemCount: _userPhotos.length,
              itemBuilder: (context, index) {
                final photo = _userPhotos[index];
                return ListTile(
                  title: Text(photo.name),
                  subtitle: Text(photo.description),
                  leading: Image.file(File(photo.imagePath)),
                );
              },
            ),
    );
  }
}
