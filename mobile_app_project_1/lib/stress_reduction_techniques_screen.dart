import 'package:flutter/material.dart';
import 'activity_storage.dart';

class StressReductionTechniquesScreen extends StatefulWidget {
  const StressReductionTechniquesScreen({super.key});

  @override
  _StressReductionTechniquesScreenState createState() =>
      _StressReductionTechniquesScreenState();
}

class _StressReductionTechniquesScreenState
    extends State<StressReductionTechniquesScreen> {
  List<StressReductionTechnique> techniques = [
    StressReductionTechnique(
      title: 'Progressive Muscle Relaxation',
      description:
          'Tense and relax different muscle groups to reduce overall tension.',
      duration: 15,
      category: 'Physical',
      detailedInstructions: [
        'Find a comfortable position sitting or lying down.',
        'Start with your toes, tense them for 5 seconds, then relax.',
        'Move up to your calves, tense for 5 seconds, then relax.',
        'Continue this process moving up through your body.',
        'End with tensing and relaxing your facial muscles.',
      ],
    ),
    StressReductionTechnique(
      title: 'Guided Imagery',
      description: 'Visualize a peaceful, calming scene or experience.',
      duration: 10,
      category: 'Mental',
      detailedInstructions: [
        'Find a quiet, comfortable place to sit or lie down.',
        'Close your eyes and take a few deep breaths.',
        'Imagine a peaceful scene, like a beach or forest.',
        'Engage all your senses in the visualization.',
        'Spend 5-10 minutes immersed in this peaceful imagery.',
      ],
    ),
  ];

  List<StressReductionTechnique> filteredTechniques = [];
  String searchQuery = '';
  String selectedCategory = 'All';
  String sortBy = 'Title';

  @override
  void initState() {
    super.initState();
    filteredTechniques = techniques;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stress Reduction Techniques'),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterAndSort(),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTechniques.length,
              itemBuilder: (context, index) {
                return _buildTechniqueItem(filteredTechniques[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTechnique,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Search techniques',
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: (value) {
          setState(() {
            searchQuery = value;
            _filterAndSortTechniques();
          });
        },
      ),
    );
  }

  Widget _buildFilterAndSort() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedCategory,
              items: ['All', ...techniques.map((t) => t.category).toSet()]
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                  _filterAndSortTechniques();
                });
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButton<String>(
              isExpanded: true,
              value: sortBy,
              items: ['Title', 'Duration']
                  .map((sort) => DropdownMenuItem(
                        value: sort,
                        child: Text('Sort by $sort'),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  sortBy = value!;
                  _filterAndSortTechniques();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void _filterAndSortTechniques() {
    filteredTechniques = techniques.where((technique) {
      bool matchesSearch =
          technique.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
              technique.description
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase());
      bool matchesCategory =
          selectedCategory == 'All' || technique.category == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    filteredTechniques.sort((a, b) {
      switch (sortBy) {
        case 'Duration':
          return a.duration.compareTo(b.duration);
        default:
          return a.title.compareTo(b.title);
      }
    });
  }

  Widget _buildTechniqueItem(StressReductionTechnique technique) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        title: Text(technique.title),
        subtitle: Text('${technique.duration} min | ${technique.category}'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(technique.description),
                const SizedBox(height: 8),
                const Text('Instructions:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...technique.detailedInstructions.map((step) => Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                      child: Text('• $step'),
                    )),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _startTechnique(technique),
                  child: const Text('Start Technique'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addTechnique() {
    _showTechniqueDialog();
  }

  void _showTechniqueDialog({StressReductionTechnique? technique}) {
    final isEditing = technique != null;
    final titleController = TextEditingController(text: technique?.title ?? '');
    final descriptionController =
        TextEditingController(text: technique?.description ?? '');
    final durationController =
        TextEditingController(text: technique?.duration.toString() ?? '');
    final categoryController =
        TextEditingController(text: technique?.category ?? '');
    final instructionsController = TextEditingController(
        text: technique?.detailedInstructions.join('\n') ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Technique' : 'Add Technique'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: durationController,
                  decoration:
                      const InputDecoration(labelText: 'Duration (minutes)'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                TextField(
                  controller: instructionsController,
                  decoration: const InputDecoration(
                      labelText: 'Detailed Instructions (one per line)'),
                  maxLines: 5,
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
                final newTechnique = StressReductionTechnique(
                  title: titleController.text,
                  description: descriptionController.text,
                  duration: int.tryParse(durationController.text) ?? 0,
                  category: categoryController.text,
                  detailedInstructions: instructionsController.text.split('\n'),
                );

                setState(() {
                  if (isEditing) {
                    final index = techniques.indexOf(technique);
                    techniques[index] = newTechnique;
                  } else {
                    techniques.add(newTechnique);
                  }
                  _filterAndSortTechniques();
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

  void _startTechnique(StressReductionTechnique technique) {
    ActivityStorage.addActivityFromScreen(
        'Stress Reduction', 'Started ${technique.title}');
    // TODO: Implement starting the technique (e.g., navigate to a new screen or show a timer)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Started ${technique.title}')),
    );
  }
}

class StressReductionTechnique {
  final String title;
  final String description;
  final int duration;
  final String category;
  final List<String> detailedInstructions;

  StressReductionTechnique({
    required this.title,
    required this.description,
    required this.duration,
    required this.category,
    required this.detailedInstructions,
  });
}
