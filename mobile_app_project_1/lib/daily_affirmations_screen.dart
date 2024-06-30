import 'package:flutter/material.dart';
import 'dart:async';

class DailyAffirmationsScreen extends StatefulWidget {
  const DailyAffirmationsScreen({super.key});

  @override
  _DailyAffirmationsScreenState createState() =>
      _DailyAffirmationsScreenState();
}

class _DailyAffirmationsScreenState extends State<DailyAffirmationsScreen> {
  List<Affirmation> affirmations = [
    Affirmation(text: 'I am capable of achieving great things.'),
    Affirmation(text: 'I choose to be happy and positive today.'),
    Affirmation(text: 'I am worthy of love and respect.'),
    Affirmation(text: 'I embrace new challenges as opportunities for growth.'),
  ];

  late Affirmation currentAffirmation;
  List<Affirmation> filteredAffirmations = [];
  String searchQuery = '';
  Timer? _dailyTimer;

  @override
  void initState() {
    super.initState();
    currentAffirmation = affirmations.isNotEmpty
        ? affirmations[0]
        : Affirmation(text: 'Default affirmation');
    filteredAffirmations = affirmations;
    _startDailyAffirmationTimer();
  }

  @override
  void dispose() {
    _dailyTimer?.cancel();
    super.dispose();
  }

  void _startDailyAffirmationTimer() {
    _dailyTimer = Timer.periodic(const Duration(hours: 24), (_) {
      _changeAffirmation();
    });
  }

  void _changeAffirmation() {
    setState(() {
      final currentIndex = affirmations.indexOf(currentAffirmation);
      final newIndex = (currentIndex + 1) % affirmations.length;
      currentAffirmation = affirmations[newIndex];
    });
  }

  void _showAffirmationNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('New daily affirmation: ${currentAffirmation.text}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Affirmations'),
      ),
      body: Column(
        children: [
          _buildCurrentAffirmation(),
          const Divider(),
          _buildSearchBar(),
          Expanded(
            child: _buildAffirmationList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAffirmation,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCurrentAffirmation() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Today\'s Affirmation',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            currentAffirmation.text,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _changeAffirmation,
                child: const Text('Change Affirmation'),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: Icon(
                  currentAffirmation.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () => _toggleFavorite(currentAffirmation),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Search affirmations',
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: (value) {
          setState(() {
            searchQuery = value;
            _filterAffirmations();
          });
        },
      ),
    );
  }

  void _filterAffirmations() {
    filteredAffirmations = affirmations.where((affirmation) {
      return affirmation.text.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  Widget _buildAffirmationList() {
    return ListView.builder(
      itemCount: filteredAffirmations.length,
      itemBuilder: (context, index) {
        return _buildAffirmationItem(filteredAffirmations[index]);
      },
    );
  }

  Widget _buildAffirmationItem(Affirmation affirmation) {
    return ListTile(
      title: Text(affirmation.text),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              affirmation.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () => _toggleFavorite(affirmation),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editAffirmation(affirmation),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteAffirmation(affirmation),
          ),
        ],
      ),
    );
  }

  void _addAffirmation() {
    _showAffirmationDialog();
  }

  void _editAffirmation(Affirmation affirmation) {
    _showAffirmationDialog(affirmation: affirmation);
  }

  void _deleteAffirmation(Affirmation affirmation) {
    setState(() {
      affirmations.remove(affirmation);
      _filterAffirmations();
    });
  }

  void _toggleFavorite(Affirmation affirmation) {
    setState(() {
      affirmation.isFavorite = !affirmation.isFavorite;
    });
  }

  void _showAffirmationDialog({Affirmation? affirmation}) {
    final isEditing = affirmation != null;
    final textController = TextEditingController(text: affirmation?.text ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Affirmation' : 'Add Affirmation'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(labelText: 'Affirmation'),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newAffirmation = Affirmation(
                  text: textController.text,
                );

                setState(() {
                  if (isEditing) {
                    final index = affirmations.indexOf(affirmation);
                    affirmations[index] = newAffirmation;
                  } else {
                    affirmations.add(newAffirmation);
                  }
                  _filterAffirmations();
                });

                Navigator.pop(context);
              },
              child: Text(isEditing ? 'Save' : 'Add'),
            ),
          ],
        );
      },
    );
  }
}

class Affirmation {
  final String text;
  bool isFavorite;

  Affirmation({
    required this.text,
    this.isFavorite = false,
  });
}

