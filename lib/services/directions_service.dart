import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/trip_plan.dart';

class DirectionsService {
  static const String _apiKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY');

  /// Fetches polylines and duration between consecutive activities.
  /// Modifies and returns the updated activities list with 'travelDurationToNext' fields filled.
  Future<Map<String, dynamic>> getRouteDetails(List<Activity> activities) async {
    List<Activity> enrichedActivities = List.from(activities);
    List<LatLng> routePoints = [];

    if (activities.length < 2) {
      return {
        'activities': enrichedActivities,
        'polylines': routePoints,
      };
    }

    for (int i = 0; i < activities.length - 1; i++) {
      final origin = activities[i];
      final dest = activities[i + 1];

      if (origin.latitude == null || origin.longitude == null || 
          dest.latitude == null || dest.longitude == null) {
        continue;
      }

      if (_apiKey.isEmpty) {
        // Mock fallback route calculations
        final mockData = _calculateMockDistanceAndDuration(
          origin.latitude!, origin.longitude!, 
          dest.latitude!, dest.longitude!
        );
        
        enrichedActivities[i] = origin.copyWith(
          travelDurationToNext: '${mockData['duration']} mins drive • ${mockData['distance']} km',
        );

        // Add direct line points with a slight curve to make maps look beautiful!
        routePoints.addAll(_generateMockRoutePoints(
          LatLng(origin.latitude!, origin.longitude!),
          LatLng(dest.latitude!, dest.longitude!)
        ));
        continue;
      }

      try {
        final url = 'https://maps.googleapis.com/maps/api/directions/json?'
            'origin=${origin.latitude},${origin.longitude}'
            '&destination=${dest.latitude},${dest.longitude}'
            '&mode=driving&key=$_apiKey';

        final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
        if (response.statusCode != 200) {
          throw Exception('Directions API returned status code ${response.statusCode}');
        }

        final data = json.decode(response.body);
        final List routes = data['routes'] ?? [];

        if (routes.isEmpty) {
          throw Exception('No routes found');
        }

        final leg = routes[0]['legs'][0];
        final distanceText = leg['distance']['text'] ?? '';
        final durationText = leg['duration']['text'] ?? '';

        enrichedActivities[i] = origin.copyWith(
          travelDurationToNext: '$durationText drive • $distanceText',
        );

        // Decode overview_polyline
        final String encodedPoly = routes[0]['overview_polyline']['points'] ?? '';
        routePoints.addAll(decodePolyline(encodedPoly));
      } catch (_) {
        // Fail-safe local calculations
        final mockData = _calculateMockDistanceAndDuration(
          origin.latitude!, origin.longitude!, 
          dest.latitude!, dest.longitude!
        );
        enrichedActivities[i] = origin.copyWith(
          travelDurationToNext: '${mockData['duration']} mins drive • ${mockData['distance']} km',
        );
        routePoints.addAll(_generateMockRoutePoints(
          LatLng(origin.latitude!, origin.longitude!),
          LatLng(dest.latitude!, dest.longitude!)
        ));
      }
    }

    return {
      'activities': enrichedActivities,
      'polylines': routePoints,
    };
  }

  /// Calculates spherical distances between lat/lng points cleanly and reliably.
  Map<String, dynamic> _calculateMockDistanceAndDuration(double lat1, double lng1, double lat2, double lng2) {
    const double p = 0.017453292519943295; // Pi/180
    final double a = 0.5 - math.cos((lat2 - lat1) * p) / 2 +
        math.cos(lat1 * p) * math.cos(lat2 * p) * (1 - math.cos((lng2 - lng1) * p)) / 2;
    
    final double distanceKm = 12742 * math.asin(math.sqrt(a)); // R = 6371 km
    final int durationMins = math.max(3, (distanceKm * 2.2 + 5).round());

    return {
      'distance': distanceKm.toStringAsFixed(1),
      'duration': durationMins,
    };
  }

  /// Generates a realistic curved path of points between origin and destination so polylines look stunning
  List<LatLng> _generateMockRoutePoints(LatLng origin, LatLng dest) {
    List<LatLng> points = [];
    const int steps = 12;
    for (int i = 0; i <= steps; i++) {
      final double t = i / steps;
      final double lat = origin.latitude + (dest.latitude - origin.latitude) * t;
      final double lng = origin.longitude + (dest.longitude - origin.longitude) * t;
      
      // Add a slight arc/wave to the line so it is visually dynamic instead of a strict straight line
      final double arc = math.sin(t * math.pi) * 0.003 * (origin.latitude - dest.latitude).abs();
      points.add(LatLng(lat + arc, lng - arc));
    }
    return points;
  }

  /// Decodes Google's standard encoded polyline strings into coordinate points
  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      poly.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return poly;
  }
}
