import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_app/controllers/auth_controller.dart';
import 'package:flutter_app/controllers/photo_controller.dart';
import 'package:flutter_app/model/photo.dart';
import 'package:flutter_app/screens/camera_page.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

class PhotoCaptureView extends StatefulWidget {
  const PhotoCaptureView({super.key});

  @override
  _PhotoCaptureViewState createState() => _PhotoCaptureViewState();
}

class _PhotoCaptureViewState extends State<PhotoCaptureView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  late PhotoController _photoController;
  late AuthController _authController;
  late CameraController _cameraController;
  late Future<void> _cameraInitialization;
  File? _image;
  //late XFile? _picture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    //_picture = null;
    _initializeCamera();
    _photoController = PhotoController();
    _initializeAuthController();
    _initializeLocationPermissions();
  }

  Future<void> _initializeAuthController() async {
    _authController = AuthController(await SharedPreferences.getInstance());
  }

  @override
  void dispose() {
    if (_cameraController.value.isInitialized) {
      _cameraController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _image != null
                      ? _buildImagePreview()
                      : Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await _initializeCamera();
                                XFile? picture = await _checkAndTakePicture();
                                if (picture != null) {
                                  setState(() {
                                    _image = File(picture.path);
                                  });
                                }
                              },
                              child: Container(
                                height: 300,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 199, 198, 198),
                                  border: Border.all(
                                      color: Colors.black, width: 2.0),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Insert Photo Here',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: descriptionController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.cyan,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 50),
                    ),
                    onPressed: () async {
                      if (_image == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please take a picture first.'),
                          ),
                        );
                        return;
                      } else {
                        await _savePhoto();
                        Navigator.popUntil(
                            context, ModalRoute.withName('/home'));
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    },
                    child: const Text('Save Photo'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.2),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return Column(
      children: [
        Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2.0),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18.0),
            child: Image.file(
              _image!,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          ),
          onPressed: () {
            setState(() {
              _image = null;
            });
          },
          child: const Text('Remove Photo'),
        ),
      ],
    );
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
      _cameraInitialization = _cameraController.initialize();
      await _cameraInitialization;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No cameras available'),
        ),
      );
    }
  }

  Future<XFile?> _checkAndTakePicture() async {
    await _initializeLocationPermissions();

    final permissionStatus = await _getLocationPermissionStatus();

    if (permissionStatus == LocationPermission.always ||
        permissionStatus == LocationPermission.whileInUse) {
      await _goToPreview();
    } else {
      return null;
    }
    return null;
  }

  Future<LocationPermission> _getLocationPermissionStatus() async {
    return await Geolocator.checkPermission();
  }

  Future<void> _goToPreview() async {
    String? userId = await _authController.getUserId();

    if (userId != null) {
      List<CameraDescription>? cameras = await availableCameras();

      // ignore: use_build_context_synchronously
      XFile? picture = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CameraPage(cameras: cameras),
        ),
      );

      if (picture != null) {
        setState(() {
          _image = File(picture.path);
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to take photo. User ID is null.'),
        ),
      );
    }
  }

  Future<void> _savePhoto() async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (_image != null) {
        String? userId = await _authController.getUserId();

        if (userId != null) {
          Position position = await _photoController.determineCustomPosition();
          const uuid = Uuid();
          var photo = Photo(
            id: uuid.v4(),
            name: nameController.text,
            description: descriptionController.text,
            rating: 0,
            imagePath: File(_image!.path).path,
            latitude: position.latitude,
            longitude: position.longitude,
            timestamp: DateTime.now(),
          );

          await _authController.savePhoto(photo);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Photo saved successfully!'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to save photo. User ID is null.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please take a picture first.'),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _initializeLocationPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
  }
}
