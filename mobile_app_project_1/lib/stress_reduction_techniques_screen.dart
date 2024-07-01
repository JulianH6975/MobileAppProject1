import 'package:flutter/material.dart';
import 'technique_instructions_screen.dart';

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
        'Repeat this process until you are satisfied',
        'End with tensing and relaxing your facial muscles.',
      ],
    ),
    StressReductionTechnique(
      title: 'Aromatherapy',
      description:
          'Use essential oils to promote relaxation and reduce stress.',
      duration: 15,
      category: 'Sensory',
      detailedInstructions: [
        'Choose a calming essential oil like lavender, chamomile, or ylang-ylang.',
        'Add a few drops to a diffuser or mix with a carrier oil.',
        'Find a comfortable spot to sit or lie down.',
        'Breathe in the aroma deeply for 15 minutes.',
        'Focus on the scent and how it makes you feel.',
      ],
    ),
    StressReductionTechnique(
      title: 'Art Therapy',
      description:
          'Express your feelings through creative activities to reduce stress.',
      duration: 30,
      category: 'Creative',
      detailedInstructions: [
        'Gather art supplies (paper, colors, brushes, etc.).',
        'Set aside 30 minutes of uninterrupted time.',
        'Start creating without judgment - draw, paint, or sculpt.',
        'Focus on expressing your emotions through your art.',
        'Reflect on your creation and how the process made you feel.',
      ],
    ),
    StressReductionTechnique(
      title: 'Yoga',
      description:
          'Combine physical postures, breathing techniques, and meditation.',
      duration: 20,
      category: 'Physical',
      detailedInstructions: [
        'Start with a few minutes of deep breathing.',
        'Practice basic yoga poses like mountain pose, child pose, and downward dog.',
        'Hold each pose for 30 seconds to 1 minute.',
        'Focus on your breath and body sensations throughout the practice.',
        'End with a few minutes of relaxation in corpse pose.',
      ],
    ),
    StressReductionTechnique(
      title: 'Journaling',
      description: 'Write down your thoughts and feelings to process emotions.',
      duration: 15,
      category: 'Mental',
      detailedInstructions: [
        'Find a quiet place and grab a pen and paper or a digital device.',
        'Set a timer for 15 minutes.',
        'Write continuously about your thoughts, feelings, and experiences.',
        'Don not worry about grammar or structure; just let your thoughts flow.',
        'After 15 minutes, review what you have written if you would like.',
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
      child: ListTile(
        title: Text(technique.title),
        subtitle: Text('${technique.duration} min | ${technique.category}'),
        trailing: ElevatedButton(
          onPressed: () => _startTechnique(technique),
          child: const Text('Start'),
        ),
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
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TechniqueInstructionsScreen(technique: technique),
    ));
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
