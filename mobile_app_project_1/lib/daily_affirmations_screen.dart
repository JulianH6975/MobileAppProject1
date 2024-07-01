import 'package:flutter/material.dart';

class DailyAffirmationsScreen extends StatefulWidget {
  const DailyAffirmationsScreen({Key? key}) : super(key: key);

  @override
  _DailyAffirmationsScreenState createState() =>
      _DailyAffirmationsScreenState();
}

class _DailyAffirmationsScreenState extends State<DailyAffirmationsScreen> {
  List<String> affirmations = [
    'I am capable of achieving great things.',
    'I choose to be happy and positive today.',
    'I am worthy of love and respect.',
    'I embrace new challenges as opportunities for growth.',
    'I am confident in my abilities.',
  ];

  List<String> filteredAffirmations = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredAffirmations = List.from(affirmations);
  }

  void _filterAffirmations(String query) {
    setState(() {
      searchQuery = query;
      filteredAffirmations = affirmations
          .where((affirmation) =>
              affirmation.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Affirmations'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search affirmations',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterAffirmations,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredAffirmations.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredAffirmations[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        affirmations.remove(filteredAffirmations[index]);
                        _filterAffirmations(searchQuery);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAffirmation,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addAffirmation() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add Affirmation'),
          content: TextField(
            controller: controller,
            decoration:
                const InputDecoration(hintText: 'Enter your affirmation'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    affirmations.add(controller.text);
                    _filterAffirmations(searchQuery);
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
