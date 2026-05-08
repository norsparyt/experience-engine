class TripPlan {
  final String tripSummary;
  final String totalEstimatedBudget;
  final List<TripDay> days;

  TripPlan({
    required this.tripSummary,
    required this.totalEstimatedBudget,
    required this.days,
  });

  factory TripPlan.fromJson(Map<String, dynamic> json) {
    return TripPlan(
      tripSummary: json['trip_summary'] ?? '',
      totalEstimatedBudget: json['total_estimated_budget'] ?? '',
      days: (json['days'] as List<dynamic>?)
              ?.map((dayJson) => TripDay.fromJson(dayJson as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trip_summary': tripSummary,
      'total_estimated_budget': totalEstimatedBudget,
      'days': days.map((day) => day.toJson()).toList(),
    };
  }
}

class TripDay {
  final int day;
  final List<Activity> activities;

  TripDay({
    required this.day,
    required this.activities,
  });

  factory TripDay.fromJson(Map<String, dynamic> json) {
    return TripDay(
      day: json['day'] ?? 0,
      activities: (json['activities'] as List<dynamic>?)
              ?.map((actJson) => Activity.fromJson(actJson as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'activities': activities.map((act) => act.toJson()).toList(),
    };
  }
}

class Activity {
  final String time;
  final String title;
  final String description;
  final String estimatedCost;
  final String reasoning;
  
  // Phase 2 Geographic and enrichment fields
  final double? latitude;
  final double? longitude;
  final String? placeId;
  final double? rating;
  final String? imageUrl;
  final String? address;
  final String? openingHours;
  final String? travelDurationToNext;

  Activity({
    required this.time,
    required this.title,
    required this.description,
    required this.estimatedCost,
    required this.reasoning,
    this.latitude,
    this.longitude,
    this.placeId,
    this.rating,
    this.imageUrl,
    this.address,
    this.openingHours,
    this.travelDurationToNext,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      time: json['time'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      estimatedCost: json['estimated_cost'] ?? '',
      reasoning: json['reasoning'] ?? '',
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
      placeId: json['placeId'],
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      imageUrl: json['imageUrl'],
      address: json['address'],
      openingHours: json['openingHours'],
      travelDurationToNext: json['travelDurationToNext'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'title': title,
      'description': description,
      'estimated_cost': estimatedCost,
      'reasoning': reasoning,
      'latitude': latitude,
      'longitude': longitude,
      'placeId': placeId,
      'rating': rating,
      'imageUrl': imageUrl,
      'address': address,
      'openingHours': openingHours,
      'travelDurationToNext': travelDurationToNext,
    };
  }

  Activity copyWith({
    String? time,
    String? title,
    String? description,
    String? estimatedCost,
    String? reasoning,
    double? latitude,
    double? longitude,
    String? placeId,
    double? rating,
    String? imageUrl,
    String? address,
    String? openingHours,
    String? travelDurationToNext,
  }) {
    return Activity(
      time: time ?? this.time,
      title: title ?? this.title,
      description: description ?? this.description,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      reasoning: reasoning ?? this.reasoning,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      placeId: placeId ?? this.placeId,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      address: address ?? this.address,
      openingHours: openingHours ?? this.openingHours,
      travelDurationToNext: travelDurationToNext ?? this.travelDurationToNext,
    );
  }
}
