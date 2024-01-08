import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/auth_controller.dart';
import 'package:flutter_app/controllers/photo_controller.dart';
import 'package:flutter_app/model/photo.dart';
import 'package:flutter_app/screens/editphoto_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class UserPhotosScreen extends StatefulWidget {
  final AuthController? authController;

  const UserPhotosScreen({Key? key, required this.authController})
      : super(key: key);

  @override
  _UserPhotosScreenState createState() => _UserPhotosScreenState();
}

class _UserPhotosScreenState extends State<UserPhotosScreen> {
  final PhotoController _photoController = PhotoController();

  late AuthController _authController;
  late List<Photo> _userPhotos = [];
  late String userId;
  Map<String, String> locationNames = {};

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

      userId = (await _authController.getUserId())!;

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
      await _updateLocationNames();
    } catch (e) {
      print('Error loading user photos: $e');
    }
  }

  Future<void> _updateLocationNames() async {
    for (var photo in _userPhotos) {
      String locationName = await _photoController.getLocationName(
          photo.latitude, photo.longitude);
      setState(() {
        locationNames[photo.id] = locationName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _userPhotos.isEmpty
          ? const Center(child: Text('No photos available.'))
          : ListView.builder(
              itemCount: _userPhotos.length,
              itemBuilder: (context, index) {
                final photo = _userPhotos[index];

                String locationName =
                    locationNames[photo.id] ?? 'Loading location...';
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPhotoView(
                            photo: photo,
                            userId: userId,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Image.file(
                            File(photo.imagePath),
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  photo.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(photo.description),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    RatingBar.builder(
                                      initialRating: photo.rating.toDouble(),
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: false,
                                      itemCount: 5,
                                      itemSize: 20,
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        setState(() {
                                          photo.rating = rating.toInt();
                                        });
                                        _photoController.updatePhoto(
                                            photo, userId);
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.location_on),
                                    Text(locationName),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      color: Colors.red,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Delete Photo'),
                                              content: const Text(
                                                  'Are you sure you want to delete this photo?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await deletePhoto(photo);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Delete'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  ' ${converterDateTimeParaString(photo.timestamp.toLocal())}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> deletePhoto(Photo photo) async {
    try {
      await _photoController.deletePhoto(photo.id, userId);
      _loadUserPhotos();
    } catch (e) {
      print('Error deleting photo: $e');
    }
  }

  String converterDateTimeParaString(DateTime dateTime) {
    String formatoDataHora = 'dd/MM/yyyy HH:mm';
    String stringFormatada = DateFormat(formatoDataHora).format(dateTime);

    return stringFormatada;
  }
}
