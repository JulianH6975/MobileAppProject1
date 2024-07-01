import 'package:flutter/material.dart';
import 'dart:math';
import 'mindfulness_exercises_screen.dart';
import 'stress_reduction_techniques_screen.dart';
import 'daily_affirmations_screen.dart';
import 'mood_tracking_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final List<String> _affirmations = [
    'I am capable of achieving great things.',
    'I choose to be happy and positive today.',
    'I am worthy of love and respect.',
    'I embrace new challenges as opportunities for growth.',
    'I am confident in my abilities.',
  ];

  String get _randomAffirmation {
    final random = Random();
    return _affirmations[random.nextInt(_affirmations.length)];
  }

  @override
  Widget build(BuildContext context) {
    final currentAffirmation = _randomAffirmation;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Serenity'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to Serenity',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _buildDailyAffirmation(currentAffirmation),
                const SizedBox(height: 32),
                _buildQuickAccessGrid(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDailyAffirmation(String affirmation) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Daily Affirmation',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            affirmation,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessGrid(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              return _buildQuickAccessButton(
                'Mindfulness',
                Icons.spa,
                const MindfulnessExercisesScreen(),
                context,
              );
            case 1:
              return _buildQuickAccessButton(
                'Stress Reduction',
                Icons.favorite,
                const StressReductionTechniquesScreen(),
                context,
              );
            case 2:
              return _buildQuickAccessButton(
                'Daily Affirmations',
                Icons.format_quote,
                const DailyAffirmationsScreen(),
                context,
              );
            case 3:
              return _buildQuickAccessButton(
                'Mood Tracking',
                Icons.track_changes,
                const MoodTrackingScreen(),
                context,
              );
            default:
              return Container();
          }
        },
      );
    });
  }

  Widget _buildQuickAccessButton(
    String label,
    IconData icon,
    Widget destination,
    BuildContext context,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
