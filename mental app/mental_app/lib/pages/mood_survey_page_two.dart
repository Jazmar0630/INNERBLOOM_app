 import 'package:flutter/material.dart';
import 'mood_survey_data.dart';
import 'mood_tracker_screen.dart'; // make sure this file exists

class MoodSurveyPageTwo extends StatelessWidget {
  final MoodSurveyData data;
  const MoodSurveyPageTwo({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mood Survey — Page 2')),
      body: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.black, // match MoodTracker background
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick check before you start:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text('Stress level: ${data.q1.toStringAsFixed(0)} / 4',
                style: const TextStyle(color: Colors.white)),
            Text('Sleep quality: ${data.q2.toStringAsFixed(0)} / 4',
                style: const TextStyle(color: Colors.white)),
            Text('Focus level: ${data.q3.toStringAsFixed(0)} / 4',
                style: const TextStyle(color: Colors.white)),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    // This is the “Answer now” action that goes to Mood Tracker page
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MoodTrackerScreen(),
                        ),
                      );
                    },
                    child: const Text('Answer now'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
