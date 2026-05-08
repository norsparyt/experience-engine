class Experience {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final double price;
  final double rating;
  final String duration;
  final String location;
  final List<String> tags;

  const Experience({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.price,
    required this.rating,
    required this.duration,
    required this.location,
    required this.tags,
  });
}
