import 'experience.dart';

class Destination {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String country;
  final double rating;
  final String category;
  final List<Experience> experiences;

  const Destination({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.country,
    required this.rating,
    required this.category,
    required this.experiences,
  });
}
