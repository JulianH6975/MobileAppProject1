import 'package:flutter/material.dart';
import 'activity_storage.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  String _reminderFrequency = 'Daily';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Notifications'),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            subtitle: const Text('Receive reminders and updates'),
            value: _notifications,
            onChanged: (value) {
              setState(() {
                _notifications = value;
              });
              // TODO: Implement notification handling
            },
          ),
          ListTile(
            title: const Text('Reminder Frequency'),
            subtitle: Text(_reminderFrequency),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: _showReminderFrequencyDialog,
          ),
          const Divider(),
          _buildSectionHeader('Data Management'),
          ListTile(
            title: const Text('Reset App Data'),
            subtitle: const Text('Permanently delete all your app data'),
            onTap: _showResetConfirmationDialog,
          ),
          const Divider(),
          _buildSectionHeader('About'),
          const ListTile(
            title: Text('Version'),
            subtitle: Text('1.0.0'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  void _showReminderFrequencyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reminder Frequency'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              'Daily',
              'Weekly',
              'Monthly',
            ].map((frequency) {
              return RadioListTile<String>(
                title: Text(frequency),
                value: frequency,
                groupValue: _reminderFrequency,
                onChanged: (value) {
                  setState(() {
                    _reminderFrequency = value!;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showResetConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset App Data'),
          content: const Text(
              'Are you sure you want to reset all your app data? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await ActivityStorage.clearAllData();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All app data has been reset')),
                );
                // Optionally, you might want to navigate back to the home screen or restart the app here
              },
              child: const Text('Reset', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
