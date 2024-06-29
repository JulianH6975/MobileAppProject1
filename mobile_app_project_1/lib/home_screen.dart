import 'package:flutter/material.dart';
import 'mindfulness_exercises_screen.dart';
import 'stress_reduction_techniques_screen.dart';
import 'daily_affirmations_screen.dart';
import 'mood_tracking_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Well-being'),
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
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const Text(
                  'Welcome Back!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildDailyAffirmation(),
                const SizedBox(height: 24),
                _buildQuickAccessGrid(),
                const SizedBox(height: 24),
                const Text(
                  'Recent Activities',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
              ]),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index < 3) {
                    return ListTile(
                      title: Text('Activity ${index + 1}'),
                      subtitle: Text('Description of activity ${index + 1}'),
                      leading: const Icon(Icons.check_circle),
                    );
                  } else if (index == 3) {
                    return TextButton(
                      onPressed: () {
                        // TODO: Implement view all activities
                      },
                      child: const Text('View All Activities'),
                    );
                  }
                  return null;
                },
                childCount: 4, // 3 activities + 1 "View All" button
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyAffirmation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Affirmation',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'I am capable of handling any challenges that come my way.',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessGrid() {
    return LayoutBuilder(builder: (context, constraints) {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio:
              (constraints.maxWidth / 2) / ((constraints.maxWidth / 2) * 0.6),
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
              );
            case 1:
              return _buildQuickAccessButton(
                'Stress Reduction',
                Icons.favorite,
                const StressReductionTechniquesScreen(),
              );
            case 2:
              return _buildQuickAccessButton(
                'Daily Affirmations',
                Icons.format_quote,
                const DailyAffirmationsScreen(),
              );
            case 3:
              return _buildQuickAccessButton(
                'Mood Tracking',
                Icons.track_changes,
                const MoodTrackingScreen(),
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
