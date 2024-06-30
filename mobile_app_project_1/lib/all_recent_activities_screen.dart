import 'package:flutter/material.dart';
import 'activity_storage.dart';

class AllRecentActivitiesScreen extends StatelessWidget {
  final List<Activity> activities;

  const AllRecentActivitiesScreen({Key? key, required this.activities})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Recent Activities'),
      ),
      body: ListView.builder(
        itemCount: activities.length > 20 ? 20 : activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          return ListTile(
            title: Text(activity.title),
            subtitle: Text(activity.description),
            trailing: Text(_formatTimestamp(activity.timestamp)),
          );
        },
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
