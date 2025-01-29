class TravelQuestion {
  final String question;
  final List<String> options;
  final String category; // 'activity', 'budget', 'duration' gibi

  TravelQuestion({
    required this.question,
    required this.options,
    required this.category,
  });
}
