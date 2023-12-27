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
}
