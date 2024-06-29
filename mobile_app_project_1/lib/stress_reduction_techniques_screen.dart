import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StressReductionTechniquesScreen extends StatefulWidget {
  const StressReductionTechniquesScreen({Key? key}) : super(key: key);

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
      audioUrl: 'https://example.com/progressive_muscle_relaxation.mp3',
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
      audioUrl: 'https://example.com/guided_imagery.mp3',
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
              items: ['Title', 'Duration', 'Rating', 'Usage']
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
        case 'Rating':
          return b.rating.compareTo(a.rating);
        case 'Usage':
          return b.usageCount.compareTo(a.usageCount);
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
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                Text(technique.rating.toStringAsFixed(1)),
              ],
            ),
            Text('Used ${technique.usageCount} times'),
          ],
        ),
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
                if (technique.audioUrl.isNotEmpty)
                  ElevatedButton.icon(
                    onPressed: () => _playAudio(technique.audioUrl),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Play Guided Audio'),
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => _startTechnique(technique),
                      child: const Text('Start Technique'),
                    ),
                    _buildRatingBar(technique),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(StressReductionTechnique technique) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < technique.rating.round() ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () => _rateTechnique(technique, index + 1),
        );
      }),
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
    final audioUrlController =
        TextEditingController(text: technique?.audioUrl ?? '');

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
                TextField(
                  controller: audioUrlController,
                  decoration: const InputDecoration(labelText: 'Audio URL'),
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
                  audioUrl: audioUrlController.text,
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
    setState(() {
      technique.usageCount++;
    });
    // TODO: Implement starting the technique (e.g., navigate to a new screen or show a timer)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Started ${technique.title}')),
    );
  }

  void _rateTechnique(StressReductionTechnique technique, int rating) {
    setState(() {
      technique.rating = rating.toDouble();
      _filterAndSortTechniques();
    });
  }

  void _playAudio(String audioUrl) {
    // TODO: Implement audio playback functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Playing audio: $audioUrl')),
    );
  }
}

class StressReductionTechnique {
  final String title;
  final String description;
  final int duration;
  final String category;
  final List<String> detailedInstructions;
  final String audioUrl;
  double rating;
  int usageCount;

  StressReductionTechnique({
    required this.title,
    required this.description,
    required this.duration,
    required this.category,
    required this.detailedInstructions,
    required this.audioUrl,
    this.rating = 0.0,
    this.usageCount = 0,
  });
}
