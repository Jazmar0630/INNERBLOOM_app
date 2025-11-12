 import 'package:flutter/material.dart';
import '_shared_background.dart';
import 'mood_survey_data.dart';

class MoodSurveyPageTwo extends StatelessWidget {
  final MoodSurveyData data;
  const MoodSurveyPageTwo({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mood Survey — Page 2')),
      body: SharedBg(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Quick check before you submit:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
              const SizedBox(height: 12),
              Text('Stress: ${data.q1.toStringAsFixed(0)} / 4', style: const TextStyle(color: Colors.white)),
              Text('Sleep:  ${data.q2.toStringAsFixed(0)} / 4', style: const TextStyle(color: Colors.white)),
              Text('Focus:  ${data.q3.toStringAsFixed(0)} / 4', style: const TextStyle(color: Colors.white)),
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
                      onPressed: () {
                        // TODO: save data.toMap() to Firestore if you want.
                        // After finishing, go back to Home.
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      child: const Text('Finish'),
                    ),
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
