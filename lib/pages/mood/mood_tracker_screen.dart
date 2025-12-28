import 'package:flutter/material.dart';
import 'mood_survey_page_one.dart';
import '../model/mood_survey_data.dart';

enum Mood { happy, okay, sad, angry, calm }

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  Mood? _selectedMood;

  IconData _iconFor(Mood m) {
    switch (m) {
      case Mood.happy: return Icons.sentiment_very_satisfied;
      case Mood.okay: return Icons.sentiment_neutral;
      case Mood.sad: return Icons.sentiment_dissatisfied;
      case Mood.angry: return Icons.sentiment_very_dissatisfied;
      case Mood.calm: return Icons.sentiment_satisfied;
    }
  }

  String _labelFor(Mood m) {
    switch (m) {
      case Mood.happy: return 'Happy';
      case Mood.okay: return 'Okay';
      case Mood.sad: return 'Sad';
      case Mood.angry: return 'Angry';
      case Mood.calm: return 'Calm';
    }
  }

  Widget _moodOption(Mood mood) {
    final sel = _selectedMood == mood;
    return GestureDetector(
      onTap: () => setState(() => _selectedMood = mood),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: sel 
              ? Colors.white.withOpacity(0.25)
              : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: sel 
                ? Colors.white.withOpacity(0.6)
                : Colors.white.withOpacity(0.15),
            width: sel ? 2.5 : 1.5,
          ),
          boxShadow: sel ? [
            BoxShadow(
              color: Colors.white.withOpacity(0.2),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ] : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _iconFor(mood),
              color: Colors.white,
              size: sel ? 48 : 44,
            ),
            const SizedBox(height: 8),
            Text(
              _labelFor(mood),
              style: TextStyle(
                color: Colors.white,
                fontSize: sel ? 15 : 14,
                fontWeight: sel ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: const Text('Mood Tracker'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF3C5C5A),
        foregroundColor: Colors.white,
      ),//
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3C5C5A), Color(0xFF9DA5A9)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'HOW ARE YOU FEELING RIGHT NOW?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select the mood that best describes you',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(child: _moodOption(Mood.happy)),
                            const SizedBox(width: 12),
                            Expanded(child: _moodOption(Mood.okay)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(child: _moodOption(Mood.sad)),
                            const SizedBox(width: 12),
                            Expanded(child: _moodOption(Mood.angry)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: _moodOption(Mood.calm),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedMood == null ? null : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MoodSurveyPageOne(data: MoodSurveyData()),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF3C5C5A),
                      disabledBackgroundColor: Colors.white.withOpacity(0.3),
                      disabledForegroundColor: Colors.white.withOpacity(0.5),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      'NEXT',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],  
            ),
          ),
        ),
      ),
    );
  }
}