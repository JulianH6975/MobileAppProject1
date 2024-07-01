import 'package:flutter/material.dart';

class MindfulnessExercisesScreen extends StatefulWidget {
  const MindfulnessExercisesScreen({super.key});

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
      steps: [
        'Find a comfortable seated position',
        'Close your eyes and take a deep breath in through your nose',
        'Exhale slowly through your mouth',
        'Repeat for 5 minutes',
      ],
      imageUrl: 'lib/images/image1.jpeg',
    ),
    MindfulnessExercise(
      title: 'Body Scan',
      description: 'Gradually focus on each part of your body.',
      duration: 10,
      steps: [
        'Lie down on your back',
        'Close your eyes and take a few deep breaths',
        'Start focusing on your toes, then move up to your feet',
        'Continue moving up through your body, focusing on each part',
        'End with focusing on your head and face',
      ],
      imageUrl: 'lib/images/image2.jpeg',
    ),
    MindfulnessExercise(
      title: 'Mindful Walking',
      description: 'Practice mindfulness while walking.',
      duration: 15,
      steps: [
        'Find a quiet place to walk',
        'Start walking at a slow, comfortable pace',
        'Focus on the sensation of your feet touching the ground',
        'Notice the movement of your legs and body',
        'If your mind wanders, gently bring it back to the walking',
      ],
      imageUrl: 'lib/images/image3.jpeg',
    ),
    MindfulnessExercise(
      title: 'Loving-Kindness Meditation',
      description: 'Cultivate feelings of love and compassion.',
      duration: 10,
      steps: [
        'Sit comfortably and close your eyes',
        'Think of someone you care about',
        'Silently repeat: "May you be happy, may you be healthy, may you be safe"',
        'Extend these wishes to yourself',
        'Gradually extend to others, including strangers and all beings',
      ],
      imageUrl: 'lib/images/image4.jpeg',
    ),
    MindfulnessExercise(
      title: '5-4-3-2-1 Grounding Technique',
      description: 'Use your senses to ground yourself in the present moment.',
      duration: 5,
      steps: [
        'Look around and name 5 things you can see',
        'Name 4 things you can touch',
        'Name 3 things you can hear',
        'Name 2 things you can smell',
        'Name 1 thing you can taste',
      ],
      imageUrl: 'lib/images/image5.jpeg',
    ),
  ];

  List<MindfulnessExercise> filteredExercises = [];
  String searchQuery = '';

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

  void _filterExercises() {
    filteredExercises = exercises.where((exercise) {
      return exercise.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          exercise.description
              .toLowerCase()
              .contains(searchQuery.toLowerCase());
    }).toList();
  }

  Widget _buildExerciseItem(MindfulnessExercise exercise) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        title: Text(exercise.title),
        subtitle: Text('${exercise.duration} min'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exercise.description),
                const SizedBox(height: 8),
                if (exercise.imageUrl.isNotEmpty)
                  Image.asset(
                    exercise.imageUrl,
                    height: 180,
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
  final List<String> steps;
  final String imageUrl;

  MindfulnessExercise({
    required this.title,
    required this.description,
    required this.duration,
    required this.steps,
    required this.imageUrl,
  });
}

class ExerciseProgressScreen extends StatefulWidget {
  final MindfulnessExercise exercise;

  const ExerciseProgressScreen({super.key, required this.exercise});

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
