import 'package:flutter/material.dart';
import 'dart:async';
import 'stress_reduction_techniques_screen.dart';

class TechniqueInstructionsScreen extends StatefulWidget {
  final StressReductionTechnique technique;

  const TechniqueInstructionsScreen({Key? key, required this.technique})
      : super(key: key);

  @override
  _TechniqueInstructionsScreenState createState() =>
      _TechniqueInstructionsScreenState();
}

class _TechniqueInstructionsScreenState
    extends State<TechniqueInstructionsScreen> {
  late int _secondsRemaining;
  bool _isTimerRunning = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.technique.duration * 60;
  }

  void _startTimer() {
    setState(() {
      _isTimerRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
          _isTimerRunning = false;
        }
      });
    });
  }

  void _pauseTimer() {
    setState(() {
      _isTimerRunning = false;
      _timer?.cancel();
    });
  }

  void _resetTimer() {
    setState(() {
      _isTimerRunning = false;
      _timer?.cancel();
      _secondsRemaining = widget.technique.duration * 60;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.technique.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Instructions:',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              ...widget.technique.detailedInstructions.map((step) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text('• $step'),
                  )),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  _formatTime(_secondsRemaining),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _isTimerRunning ? _pauseTimer : _startTimer,
                    child: Text(_isTimerRunning ? 'Pause' : 'Start'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _resetTimer,
                    child: const Text('Reset'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
