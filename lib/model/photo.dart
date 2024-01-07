class Photo {
  String id;
  String name;
  String description;
  String imagePath;
  int rating;
  double latitude;
  double longitude;
  DateTime timestamp;

  Photo({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.rating,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      rating: json['rating'],
      imagePath: json['imagePath'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
