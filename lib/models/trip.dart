import 'destination.dart';
import 'experience.dart';

class Trip {
  final String id;
  final String title;
  final Destination destination;
  final DateTime startDate;
  final DateTime endDate;
  final Map<int, List<Experience>> itinerary; // Day 1, Day 2, etc. -> list of experiences
  final double totalBudget;
  final String travelStyle; // e.g. "Adventure", "Relaxation", "Cultural"

  const Trip({
    required this.id,
    required this.title,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.itinerary,
    required this.totalBudget,
    required this.travelStyle,
  });

  int get durationInDays => endDate.difference(startDate).inDays + 1;
}
