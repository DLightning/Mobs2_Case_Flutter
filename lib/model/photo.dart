class Photo {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final int rating;
  final double latitude;
  final double longitude;
  final DateTime timestamp;

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
