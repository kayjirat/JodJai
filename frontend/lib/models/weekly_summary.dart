class WeeklySummary {
  final int moodRating;
  final double moodPercentage;

  WeeklySummary({
    required this.moodRating,
    required this.moodPercentage,
  });

  factory WeeklySummary.fromJson(Map<String, dynamic> json) {
    return WeeklySummary(
      moodRating: json['mood_rating'] ?? 0, // Provide a default value
      moodPercentage: (json['mood_percentage'] ?? 0.0).toDouble(), // Provide a default value and convert to double
    );
  }
}