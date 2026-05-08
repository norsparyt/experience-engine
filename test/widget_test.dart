import 'package:flutter_test/flutter_test.dart';
import 'package:experience_engine/services/experience_engine.dart';

void main() {
  test('Experience Engine Recommendation Service Test', () {
    final service = ExperienceEngineService();
    final destination = ExperienceEngineService.destinations.first;

    final trip = service.generateRecommendedTrip(
      destination: destination,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 2)),
      maxBudget: 500,
      travelStyle: 'Adventure',
    );

    expect(trip.destination.name, equals(destination.name));
    expect(trip.durationInDays, equals(3));
    expect(trip.itinerary.length, equals(3));
    expect(trip.totalBudget, lessThanOrEqualTo(500));
  });
}
