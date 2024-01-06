import 'dart:convert';
import 'package:flutter_app/model/photo.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhotoController {
  Future<void> savePhoto(Photo photo, String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      List<String> data = prefs.getStringList(userId) ?? [];

      // Adiciona a nova foto aos dados do usuário
      data.add(json.encode({
        'id': photo.id,
        'name': photo.name,
        'description': photo.description,
        'rating': photo.rating,
        'imagePath': photo.imagePath,
        'latitude': photo.latitude,
        'longitude': photo.longitude,
        'timestamp': photo.timestamp.toIso8601String(),
      }));

      // Salva os dados no SharedPreferences
      await prefs.setStringList(userId, data);
    } catch (e) {
      print('Error saving photo: $e');
    }
  }

  Future<List<Photo>> getUserPhotos(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> data = prefs.getStringList(userId) ?? [];

      // Converte os dados para a lista de objetos Photo
      final List<Photo> userPhotos = data
          .map((jsonString) => Photo.fromJson(json.decode(jsonString)))
          .toList();

      return userPhotos;
    } catch (e) {
      print('Error loading user photos: $e');
    }

    return [];
  }

  Future<Position> determineCustomPosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } catch (e) {
      print('Error getting location: $e');
      return Position(
        latitude: 0.0,
        longitude: 0.0,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitudeAccuracy: 0,
        altitude: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );
    }
  }
}
