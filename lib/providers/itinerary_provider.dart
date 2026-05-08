import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/trip_plan.dart';
import '../services/gemini_service.dart';
import '../services/places_service.dart';
import '../services/directions_service.dart';

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
final placesServiceProvider = Provider<PlacesService>((ref) => PlacesService());
final directionsServiceProvider = Provider<DirectionsService>((ref) => DirectionsService());

// Reactive polyline route points per day (0-indexed days mapping to LatLng lists)
final routePointsProvider = StateProvider<Map<int, List<LatLng>>>((ref) => {});

class ItineraryNotifier extends StateNotifier<AsyncValue<TripPlan?>> {
  final GeminiService _geminiService;
  final PlacesService _placesService;
  final DirectionsService _directionsService;
  final Ref _ref;

  ItineraryNotifier(
    this._geminiService,
    this._placesService,
    this._directionsService,
    this._ref,
  ) : super(const AsyncValue.data(null));

  Future<void> generate(TravelPreferences prefs) async {
    state = const AsyncValue.loading();
    try {
      // 1. Fetch raw itinerary from Gemini AI
      final plan = await _geminiService.generateItinerary(
        destination: prefs.destination,
        budget: prefs.budget,
        days: prefs.days,
        interests: prefs.interests,
        pace: prefs.pace,
        foodPreference: prefs.foodPreference,
      );

      // 2. Perform dynamic Google Places & Directions Enrichment
      List<TripDay> enrichedDays = [];
      Map<int, List<LatLng>> allRoutePoints = {};

      for (int i = 0; i < plan.days.length; i++) {
        final day = plan.days[i];
        
        // Geocode and enrich every plain-text activity
        List<Activity> enrichedActivities = [];
        for (final act in day.activities) {
          final enrichedAct = await _placesService.searchAndEnrichPlace(act, prefs.destination);
          enrichedActivities.add(enrichedAct);
        }

        // Calculate actual polylines and duration/distance between stops
        final routeDetails = await _directionsService.getRouteDetails(enrichedActivities);
        
        final finalActivities = routeDetails['activities'] as List<Activity>;
        final points = routeDetails['polylines'] as List<LatLng>;

        enrichedDays.add(TripDay(day: day.day, activities: finalActivities));
        allRoutePoints[i] = points;
      }

      // Save route coordinates to state provider
      _ref.read(routePointsProvider.notifier).state = allRoutePoints;

      final enrichedPlan = TripPlan(
        tripSummary: plan.tripSummary,
        totalEstimatedBudget: plan.totalEstimatedBudget,
        days: enrichedDays,
      );

      state = AsyncValue.data(enrichedPlan);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void clear() {
    _ref.read(routePointsProvider.notifier).state = {};
    state = const AsyncValue.data(null);
  }
}

final itineraryProvider = StateNotifierProvider<ItineraryNotifier, AsyncValue<TripPlan?>>((ref) {
  final gemini = ref.watch(geminiServiceProvider);
  final places = ref.watch(placesServiceProvider);
  final directions = ref.watch(directionsServiceProvider);
  return ItineraryNotifier(gemini, places, directions, ref);
});
