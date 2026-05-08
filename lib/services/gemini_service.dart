import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/trip_plan.dart';

class GeminiService {
  // Read key securely via dart-define. No hardcoding.
  static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY');

  Future<TripPlan> generateItinerary({
    required String destination,
    required double budget,
    required int days,
    required List<String> interests,
    required String pace,
    required String foodPreference,
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'Gemini API Key is missing. Please run the application with:\n'
        '--dart-define=GEMINI_API_KEY=YOUR_KEY\n'
        'or configure it in your environment.',
      );
    }

    try {
      final model = GenerativeModel(
        model: 'gemini-flash-latest',
        apiKey: _apiKey,
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
          temperature: 0.7,
        ),
      );

      final prompt =
          '''
You are an expert travel planner and experience engine. Generate a highly personalized and structured travel itinerary based on these preferences:

- Destination: $destination
- Total Budget: \$${budget.toStringAsFixed(0)}
- Duration: $days days
- Interests: ${interests.join(', ')}
- Travel Pace: $pace
- Food Preference: $foodPreference

Design Rules:
1. Optimize the activity order logically for each day (e.g., Morning, Afternoon, Evening progression).
2. Balance travel pace ($pace) - a relaxed pace should have fewer activities, fast-paced can have more.
3. Stay within the specified overall budget of \$${budget.toStringAsFixed(0)}.
4. In the "reasoning" field, provide a compelling explanation of why this fits their interests (${interests.join(', ')}), pace ($pace), or food preference ($foodPreference).
5. For activities involving food, recommend places that match the food preference ($foodPreference).

Return strictly JSON conforming to the following structure:
{
  "trip_summary": "A cohesive, inspiring 2-3 sentence overview of the trip's tone and experiences.",
  "total_estimated_budget": "Estimated overall cost, e.g. '\$${budget.toStringAsFixed(0)}'",
  "days": [
    {
      "day": 1,
      "activities": [
        {
          "time": "e.g., 09:00 AM - 11:30 AM",
          "title": "Scenic Activity or Place",
          "description": "What to do and see there, tailored to the traveler's interests.",
          "estimated_cost": "Cost, e.g. '\$25' or 'Free'",
          "reasoning": "Why this specifically fits their $pace pace or interests."
        }
      ]
    }
  ]
}
''';

      final content = [Content.text(prompt)];
      final response = await model
          .generateContent(content)
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () =>
                throw Exception('API request timed out. Please try again.'),
          );

      final responseText = response.text;
      if (responseText == null || responseText.isEmpty) {
        throw Exception('Received empty response from Gemini API.');
      }

      // Parse JSON safely
      final Map<String, dynamic> jsonMap = json.decode(responseText);
      return TripPlan.fromJson(jsonMap);
    } catch (e) {
      if (e is FormatException) {
        throw Exception(
          'The AI returned an invalid JSON response. Please try again.',
        );
      }
      throw Exception('Failed to generate itinerary: ${e.toString()}');
    }
  }
}
