 import 'package:flutter/material.dart';
import '_shared_background.dart';
import 'mood_survey_page_one.dart';
import 'mood_survey_data.dart';

enum Mood { happy, okay, sad, angry, calm }

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  Mood? _selectedMood;

  String _emojiFor(Mood m) {
    switch (m) {
      case Mood.happy: return '😊';
      case Mood.okay:  return '😐';
      case Mood.sad:   return '😢';
      case Mood.angry: return '😠';
      case Mood.calm:  return '😌';
    }
  }

  Widget _moodEmoji(Mood mood, String label) {
    final sel = _selectedMood == mood;
    return GestureDetector(
      onTap: () => setState(() => _selectedMood = mood),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 2, color: sel ? Colors.white : Colors.white70),
              color: Colors.white.withOpacity(sel ? 0.1 : 0.05),
            ),
            child: Text(_emojiFor(mood), style: const TextStyle(fontSize: 36, color: Colors.white)),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: sel ? Colors.white : Colors.white70)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mood Tracker')),
      body: SharedBg(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _moodEmoji(Mood.happy, 'Happy'),
                  _moodEmoji(Mood.okay,  'Okay'),
                  _moodEmoji(Mood.sad,   'Sad'),
                  _moodEmoji(Mood.angry, 'Angry'),
                  _moodEmoji(Mood.calm,  'Calm'),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MoodSurveyPageOne(data: MoodSurveyData()),
                      ),
                    );
                  },
                  child: const Text('Start Survey'),
                ),
              ),
            ],  
          ),
        ),
      ),
    );
  }
}
