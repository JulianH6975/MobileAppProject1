import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'activity_storage.dart';

class MoodTrackingScreen extends StatefulWidget {
  const MoodTrackingScreen({super.key});

  @override
  _MoodTrackingScreenState createState() => _MoodTrackingScreenState();
}

class _MoodTrackingScreenState extends State<MoodTrackingScreen> {
  List<MoodEntry> moodEntries = [];
  final List<String> moodOptions = [
    'Very Bad',
    'Bad',
    'Neutral',
    'Good',
    'Very Good'
  ];

  @override
  void initState() {
    super.initState();
    _loadMoodEntries();
  }

  Future<void> _saveMoodEntries() async {
    final List<Activity> activities = moodEntries
        .map((entry) => Activity(
              title: 'Mood Entry',
              description: entry.mood,
              timestamp: entry.timestamp,
            ))
        .toList();
    await ActivityStorage.saveActivities(activities);
  }

  Future<void> _loadMoodEntries() async {
    final loadedActivities = await ActivityStorage.loadActivities();
    setState(() {
      moodEntries = loadedActivities
          .where((activity) => activity.title == 'Mood Entry')
          .map((activity) => MoodEntry(
                mood: activity.description,
                timestamp: activity.timestamp,
              ))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Tracking'),
      ),
      body: Column(
        children: [
          _buildMoodSelector(),
          const Divider(),
          _buildMoodVisualization(),
          const Divider(),
          Expanded(
            child: _buildMoodHistory(),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodSelector() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How are you feeling today?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: moodOptions.map((mood) {
              return ElevatedButton(
                onPressed: () => _logMood(mood),
                child: Text(mood),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodVisualization() {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: moodOptions.map((mood) {
          int count = moodEntries.where((entry) => entry.mood == mood).length;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 30,
                height: count * 10.0,
                color: _getMoodColor(mood),
              ),
              const SizedBox(height: 4),
              Text(mood, style: const TextStyle(fontSize: 10)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMoodHistory() {
    return ListView.builder(
      itemCount: moodEntries.length,
      itemBuilder: (context, index) {
        final entry = moodEntries[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: _getMoodColor(entry.mood),
            child: Text(
              entry.mood[0],
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(entry.mood),
          subtitle:
              Text(DateFormat('MMM d, y - HH:mm').format(entry.timestamp)),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteMoodEntry(entry),
          ),
        );
      },
    );
  }

  void _logMood(String mood) {
    setState(() {
      moodEntries.insert(0, MoodEntry(mood: mood, timestamp: DateTime.now()));
    });
    _saveMoodEntries();
  }

  void _deleteMoodEntry(MoodEntry entry) {
    setState(() {
      moodEntries.remove(entry);
    });
    _saveMoodEntries();
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'Very Bad':
        return Colors.red;
      case 'Bad':
        return Colors.orange;
      case 'Neutral':
        return Colors.yellow;
      case 'Good':
        return Colors.lightGreen;
      case 'Very Good':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class MoodEntry {
  final String mood;
  final DateTime timestamp;

  MoodEntry({required this.mood, required this.timestamp});
}
