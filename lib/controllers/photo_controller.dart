import 'package:flutter_app/model/photo.dart';

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PhotoController {
  List<Photo> photos = [];

  Future<void> savePhoto(Photo photo, String userId) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$userId.json');

      // Lê o arquivo existente ou cria um novo se não existir
      List<dynamic> data = [];
      if (await file.exists()) {
        final jsonData = await file.readAsString();
        data = json.decode(jsonData);
      }

      // Adiciona a nova foto ao arquivo
      data.add({
        'name': photo.name,
        'description': photo.description,
        'rating': photo.rating,
        'imagePath': photo.imagePath,
        'latitude': photo.latitude,
        'longitude': photo.longitude,
        'timestamp': photo.timestamp.toIso8601String(),
      });

      // Salva os dados no arquivo
      await file.writeAsString(json.encode(data));
    } catch (e) {
      print('Error saving photo: $e');
    }
  }

  Future<List<Photo>> getUserPhotos(String userId) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$userId.json');

      if (await file.exists()) {
        final jsonData = await file.readAsString();
        final List<dynamic> data = json.decode(jsonData);

        // Converte os dados para a lista de objetos Photo
        final List<Photo> userPhotos = data
            .map((json) => Photo(
                  id: json['id'],
                  name: json['name'],
                  description: json['description'],
                  rating: json['rating'],
                  imagePath: json['imagePath'],
                  latitude: json['latitude'],
                  longitude: json['longitude'],
                  timestamp: DateTime.parse(json['timestamp']),
                ))
            .toList();

        return userPhotos;
      }
    } catch (e) {
      print('Error loading user photos: $e');
    }

    return [];
  }
}
