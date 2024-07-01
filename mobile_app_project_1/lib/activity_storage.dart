import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Activity {
  final String title;
  final String description;
  final DateTime timestamp;

  Activity({
    required this.title,
    required this.description,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'timestamp': timestamp.toIso8601String(),
      };

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        title: json['title'],
        description: json['description'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}

class ActivityStorage {
  static const String _key = 'recent_activities';

  static Future<void> saveActivities(List<Activity> activities) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(
      activities.map((activity) => activity.toJson()).toList(),
    );
    await prefs.setString(_key, encodedData);
  }

  static Future<List<Activity>> loadActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString(_key);
    if (encodedData == null) return [];

    final List<dynamic> decodedData = json.decode(encodedData);
    return decodedData.map((item) => Activity.fromJson(item)).toList();
  }

  static Future<void> addActivity(Activity activity) async {
    final activities = await loadActivities();
    activities.insert(0, activity);
    if (activities.length > 5) {
      activities.removeLast(); // Keep only 5 most recent
    }
    await saveActivities(activities);
  }

  static Future<void> addActivityFromScreen(
      String screen, String action) async {
    final activity = Activity(
      title: screen,
      description: action,
      timestamp: DateTime.now(),
    );
    await addActivity(activity);
  }

  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
