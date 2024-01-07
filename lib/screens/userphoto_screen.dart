import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/auth_controller.dart';
import 'package:flutter_app/controllers/photo_controller.dart';
import 'package:flutter_app/model/photo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class UserPhotosScreen extends StatefulWidget {
  final AuthController? authController;

  UserPhotosScreen({Key? key, required this.authController}) : super(key: key);

  @override
  _UserPhotosScreenState createState() => _UserPhotosScreenState();
}

class _UserPhotosScreenState extends State<UserPhotosScreen> {
  final PhotoController _photoController = PhotoController();

  late AuthController _authController;
  late List<Photo> _userPhotos = [];
  late String userId;

  @override
  void initState() {
    super.initState();
    _initializeAuthController().then((_) {
      _loadUserPhotos();
    });
  }

  Future<void> _initializeAuthController() async {
    final prefs = await SharedPreferences.getInstance();
    _authController = widget.authController ?? AuthController(prefs);
  }

  Future<void> _loadUserPhotos() async {
    try {
      if (_authController == null) {
        print('Auth controller is null.');
        return;
      }

      userId =
          (await _authController.getUserId())!; // Atribui o valor de userId

      if (userId == null) {
        print('User ID is null.');
        return;
      }

      List<Photo> userPhotos = await _photoController.getUserPhotos(userId);

      if (userPhotos == null) {
        print('Error loading user photos.');
        return;
      }

      setState(() {
        _userPhotos = userPhotos;
      });
    } catch (e) {
      print('Error loading user photos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _userPhotos.isEmpty
          ? Center(child: Text('No photos available.'))
          : ListView.builder(
              itemCount: _userPhotos.length,
              itemBuilder: (context, index) {
                final photo = _userPhotos[index];
                return ListTile(
                  title: Text(photo.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(photo.description),
                      RatingBar.builder(
                        initialRating: photo.rating.toDouble(),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemSize: 20,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            photo.rating = rating.toInt();
                          });
                          _photoController.updatePhoto(photo, userId);
                        },
                      ),
                    ],
                  ),
                  leading: Image.file(File(photo.imagePath)),
                );
              },
            ),
    );
  }
}
