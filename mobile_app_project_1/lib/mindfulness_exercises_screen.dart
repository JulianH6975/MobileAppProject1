import 'package:flutter/material.dart';

class MindfulnessExercisesScreen extends StatefulWidget {
  const MindfulnessExercisesScreen({Key? key}) : super(key: key);

  @override
  _MindfulnessExercisesScreenState createState() =>
      _MindfulnessExercisesScreenState();
}

class _MindfulnessExercisesScreenState
    extends State<MindfulnessExercisesScreen> {
  List<MindfulnessExercise> exercises = [
    MindfulnessExercise(
      title: 'Deep Breathing',
      description: 'Focus on your breath for 5 minutes.',
      duration: 5,
      category: 'Breathing',
      steps: [
        'Find a comfortable seated position',
        'Close your eyes and take a deep breath in through your nose',
        'Exhale slowly through your mouth',
        'Repeat for 5 minutes',
      ],
      imageUrl:
          'https://images.unsplash.com/photo-1591343395902-1adcb454c4e2?q=80&w=3087&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    MindfulnessExercise(
      title: 'Body Scan',
      description: 'Gradually focus on each part of your body.',
      duration: 10,
      category: 'Relaxation',
      steps: [
        'Lie down on your back',
        'Close your eyes and take a few deep breaths',
        'Start focusing on your toes, then move up to your feet',
        'Continue moving up through your body, focusing on each part',
        'End with focusing on your head and face',
      ],
      imageUrl:
          'https://images.pexels.com/photos/3760526/pexels-photo-3760526.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    ),
  ];

  List<MindfulnessExercise> filteredExercises = [];
  String searchQuery = '';
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    filteredExercises = exercises;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mindfulness Exercises'),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryFilter(),
          Expanded(
            child: ListView.builder(
              itemCount: filteredExercises.length,
              itemBuilder: (context, index) {
                return _buildExerciseItem(filteredExercises[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExercise,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Search exercises',
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: (value) {
          setState(() {
            searchQuery = value;
            _filterExercises();
          });
        },
      ),
    );
  }

  Widget _buildCategoryFilter() {
    Set<String> categories = {'All', ...exercises.map((e) => e.category)};
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
                  _filterExercises();
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  void _filterExercises() {
    filteredExercises = exercises.where((exercise) {
      bool matchesSearch =
          exercise.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
              exercise.description
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase());
      bool matchesCategory =
          selectedCategory == 'All' || exercise.category == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  Widget _buildExerciseItem(MindfulnessExercise exercise) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        title: Text(exercise.title),
        subtitle: Text('${exercise.duration} min | ${exercise.category}'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exercise.description),
                const SizedBox(height: 8),
                if (exercise.imageUrl.isNotEmpty)
                  Image.network(
                    exercise.imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(height: 8),
                const Text('Steps:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...exercise.steps.map((step) => Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                      child: Text('• $step'),
                    )),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _startExercise(exercise),
                  child: const Text('Start Exercise'),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => _editExercise(exercise),
                      child: const Text('Edit'),
                    ),
                    TextButton(
                      onPressed: () => _deleteExercise(exercise),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addExercise() {
    _showExerciseDialog();
  }

  void _editExercise(MindfulnessExercise exercise) {
    _showExerciseDialog(exercise: exercise);
  }

  void _deleteExercise(MindfulnessExercise exercise) {
    setState(() {
      exercises.remove(exercise);
      _filterExercises();
    });
  }

  void _showExerciseDialog({MindfulnessExercise? exercise}) {
    final isEditing = exercise != null;
    final titleController = TextEditingController(text: exercise?.title ?? '');
    final descriptionController =
        TextEditingController(text: exercise?.description ?? '');
    final durationController =
        TextEditingController(text: exercise?.duration.toString() ?? '');
    final categoryController =
        TextEditingController(text: exercise?.category ?? '');
    final stepsController =
        TextEditingController(text: exercise?.steps.join('\n') ?? '');
    final imageUrlController =
        TextEditingController(text: exercise?.imageUrl ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Exercise' : 'Add Exercise'),
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
                  controller: stepsController,
                  decoration:
                      const InputDecoration(labelText: 'Steps (one per line)'),
                  maxLines: 5,
                ),
                TextField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
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
                final newExercise = MindfulnessExercise(
                  title: titleController.text,
                  description: descriptionController.text,
                  duration: int.tryParse(durationController.text) ?? 0,
                  category: categoryController.text,
                  steps: stepsController.text.split('\n'),
                  imageUrl: imageUrlController.text,
                );

                setState(() {
                  if (isEditing) {
                    final index = exercises.indexOf(exercise);
                    exercises[index] = newExercise;
                  } else {
                    exercises.add(newExercise);
                  }
                  _filterExercises();
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

  void _startExercise(MindfulnessExercise exercise) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseProgressScreen(exercise: exercise),
      ),
    );
  }
}

class MindfulnessExercise {
  final String title;
  final String description;
  final int duration;
  final String category;
  final List<String> steps;
  final String imageUrl;

  MindfulnessExercise({
    required this.title,
    required this.description,
    required this.duration,
    required this.category,
    required this.steps,
    required this.imageUrl,
  });
}

class ExerciseProgressScreen extends StatefulWidget {
  final MindfulnessExercise exercise;

  const ExerciseProgressScreen({Key? key, required this.exercise})
      : super(key: key);

  @override
  _ExerciseProgressScreenState createState() => _ExerciseProgressScreenState();
}

class _ExerciseProgressScreenState extends State<ExerciseProgressScreen> {
  int currentStepIndex = 0;
  bool isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isCompleted
                  ? 'Exercise Completed!'
                  : 'Step ${currentStepIndex + 1} of ${widget.exercise.steps.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              isCompleted
                  ? 'Great job!'
                  : widget.exercise.steps[currentStepIndex],
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: isCompleted ? null : _nextStep,
                child: Text(isCompleted ? 'Completed' : 'Next Step'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextStep() {
    setState(() {
      if (currentStepIndex < widget.exercise.steps.length - 1) {
        currentStepIndex++;
      } else {
        isCompleted = true;
      }
    });
  }
}
