import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;
  String _reminderFrequency = 'Daily';
  bool _soundEffects = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('App Preferences'),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Enable dark theme for the app'),
            value: _darkMode,
            onChanged: (value) {
              setState(() {
                _darkMode = value;
              });
              // TODO: Implement dark mode functionality
            },
          ),
          SwitchListTile(
            title: const Text('Sound Effects'),
            subtitle: const Text('Enable sound effects in the app'),
            value: _soundEffects,
            onChanged: (value) {
              setState(() {
                _soundEffects = value;
              });
              // TODO: Implement sound effects functionality
            },
          ),
          const Divider(),
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
            title: const Text('Export Data'),
            subtitle: const Text('Export your app data as a file'),
            onTap: () {
              // TODO: Implement data export functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Data export not implemented yet')),
              );
            },
          ),
          ListTile(
            title: const Text('Delete All Data'),
            subtitle: const Text('Permanently delete all your app data'),
            onTap: _showDeleteConfirmationDialog,
          ),
          const Divider(),
          _buildSectionHeader('About'),
          ListTile(
            title: const Text('Version'),
            subtitle: const Text('1.0.0'),
          ),
          ListTile(
            title: const Text('Terms of Service'),
            onTap: () {
              // TODO: Implement Terms of Service screen
            },
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            onTap: () {
              // TODO: Implement Privacy Policy screen
            },
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

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete All Data'),
          content: const Text(
              'Are you sure you want to delete all your app data? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Implement data deletion
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All data has been deleted')),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
