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

  Activity({
    required this.time,
    required this.title,
    required this.description,
    required this.estimatedCost,
    required this.reasoning,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      time: json['time'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      estimatedCost: json['estimated_cost'] ?? '',
      reasoning: json['reasoning'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'title': title,
      'description': description,
      'estimated_cost': estimatedCost,
      'reasoning': reasoning,
    };
  }
}
