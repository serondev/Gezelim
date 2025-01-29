class TravelDestination {
  final String name;
  final String description;
  final String imageUrl;
  final List<String> activities;
  final String season;
  final double rating;
  final String? imageCredit;

  TravelDestination({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.activities,
    required this.season,
    required this.rating,
    this.imageCredit,
  });
}
