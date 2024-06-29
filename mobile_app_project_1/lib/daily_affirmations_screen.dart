import 'package:flutter/material.dart';
import 'dart:async';

class DailyAffirmationsScreen extends StatefulWidget {
  const DailyAffirmationsScreen({Key? key}) : super(key: key);

  @override
  _DailyAffirmationsScreenState createState() =>
      _DailyAffirmationsScreenState();
}

class _DailyAffirmationsScreenState extends State<DailyAffirmationsScreen> {
  List<Affirmation> affirmations = [
    Affirmation(
        text: 'I am capable of achieving great things.',
        category: 'Self-confidence'),
    Affirmation(
        text: 'I choose to be happy and positive today.',
        category: 'Positivity'),
    Affirmation(
        text: 'I am worthy of love and respect.', category: 'Self-worth'),
    Affirmation(
        text: 'I embrace new challenges as opportunities for growth.',
        category: 'Growth'),
  ];

  late Affirmation currentAffirmation;
  List<Affirmation> filteredAffirmations = [];
  String searchQuery = '';
  String selectedCategory = 'All';
  Timer? _dailyTimer;

  @override
  void initState() {
    super.initState();
    currentAffirmation = affirmations.isNotEmpty
        ? affirmations[0]
        : Affirmation(text: 'Default affirmation', category: 'Default');
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
    // TODO: Implement actual notification using a package like flutter_local_notifications
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('New daily affirmation: ${currentAffirmation.text}')),
    );
  }

  // ... rest of the code remains the same

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
          _buildCategoryFilter(),
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

  Widget _buildCategoryFilter() {
    Set<String> categories = {'All', ...affirmations.map((e) => e.category)};
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(category),
              selected: selectedCategory == category,
              onSelected: (selected) {
                setState(() {
                  selectedCategory = category;
                  _filterAffirmations();
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  void _filterAffirmations() {
    filteredAffirmations = affirmations.where((affirmation) {
      bool matchesSearch =
          affirmation.text.toLowerCase().contains(searchQuery.toLowerCase());
      bool matchesCategory =
          selectedCategory == 'All' || affirmation.category == selectedCategory;
      return matchesSearch && matchesCategory;
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
      subtitle: Text(affirmation.category),
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
    final categoryController =
        TextEditingController(text: affirmation?.category ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Affirmation' : 'Add Affirmation'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: textController,
                  decoration: const InputDecoration(labelText: 'Affirmation'),
                  maxLines: 3,
                ),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
              ],
            ),
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
                  category: categoryController.text,
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
  final String category;
  bool isFavorite;

  Affirmation({
    required this.text,
    required this.category,
    this.isFavorite = false,
  });
}
