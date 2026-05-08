import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/trip_plan.dart';
import '../services/gemini_service.dart';

class TravelPreferences {
  final String destination;
  final double budget;
  final int days;
  final List<String> interests;
  final String pace;
  final String foodPreference;

  TravelPreferences({
    this.destination = '',
    this.budget = 5000.0,
    this.days = 3,
    this.interests = const [],
    this.pace = 'Balanced',
    this.foodPreference = 'No preference',
  });

  TravelPreferences copyWith({
    String? destination,
    double? budget,
    int? days,
    List<String>? interests,
    String? pace,
    String? foodPreference,
  }) {
    return TravelPreferences(
      destination: destination ?? this.destination,
      budget: budget ?? this.budget,
      days: days ?? this.days,
      interests: interests ?? this.interests,
      pace: pace ?? this.pace,
      foodPreference: foodPreference ?? this.foodPreference,
    );
  }
}

class PreferencesNotifier extends StateNotifier<TravelPreferences> {
  PreferencesNotifier() : super(TravelPreferences());

  void updateDestination(String dest) => state = state.copyWith(destination: dest);
  void updateBudget(double budget) => state = state.copyWith(budget: budget);
  void updateDays(int days) => state = state.copyWith(days: days);
  
  void toggleInterest(String interest) {
    final current = List<String>.from(state.interests);
    if (current.contains(interest)) {
      current.remove(interest);
    } else {
      current.add(interest);
    }
    state = state.copyWith(interests: current);
  }
  
  void updatePace(String pace) => state = state.copyWith(pace: pace);
  void updateFoodPreference(String food) => state = state.copyWith(foodPreference: food);
  
  void reset() => state = TravelPreferences();
}

final preferencesProvider = StateNotifierProvider<PreferencesNotifier, TravelPreferences>((ref) {
  return PreferencesNotifier();
});

final geminiServiceProvider = Provider<GeminiService>((ref) => GeminiService());

class ItineraryNotifier extends StateNotifier<AsyncValue<TripPlan?>> {
  final GeminiService _geminiService;

  ItineraryNotifier(this._geminiService) : super(const AsyncValue.data(null));

  Future<void> generate(TravelPreferences prefs) async {
    state = const AsyncValue.loading();
    try {
      final plan = await _geminiService.generateItinerary(
        destination: prefs.destination,
        budget: prefs.budget,
        days: prefs.days,
        interests: prefs.interests,
        pace: prefs.pace,
        foodPreference: prefs.foodPreference,
      );
      state = AsyncValue.data(plan);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void clear() {
    state = const AsyncValue.data(null);
  }
}

final itineraryProvider = StateNotifierProvider<ItineraryNotifier, AsyncValue<TripPlan?>>((ref) {
  final service = ref.watch(geminiServiceProvider);
  return ItineraryNotifier(service);
});
