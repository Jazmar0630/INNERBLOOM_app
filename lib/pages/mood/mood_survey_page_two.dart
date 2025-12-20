import 'package:flutter/material.dart';
import '../widgets/_shared_background.dart';
import '../model/mood_survey_data.dart';
import '../mood/mood_result.dart';

class MoodSurveyPageTwo extends StatefulWidget {
  final MoodSurveyData data;
  const MoodSurveyPageTwo({super.key, required this.data});

  @override
  State<MoodSurveyPageTwo> createState() => _MoodSurveyPageTwoState();
}

class _MoodSurveyPageTwoState extends State<MoodSurveyPageTwo> {
  // slider widget like page 1
  Widget _sliderBlock(String question, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        Slider(
          value: value,
          min: 0,
          max: 4,
          divisions: 4,
          label: value.round().toString(),
          onChanged: onChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Never', style: TextStyle(color: Colors.white)),
            Text('Rarely', style: TextStyle(color: Colors.white)),
            Text('Sometimes', style: TextStyle(color: Colors.white)),
            Text('Often', style: TextStyle(color: Colors.white)),
            Text('Always', style: TextStyle(color: Colors.white)),
          ],
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return Scaffold(
      appBar: AppBar(title: const Text('Mood Survey — Page 2')),
      body: SharedBg(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ sliders (Page 2 uses q4, q5, q6)
              _sliderBlock(
                'I feel overwhelmed by tasks or responsibilities today.',
                data.q4,
                (v) => setState(() => data.q4 = v),
              ),
              _sliderBlock(
                'I had trouble falling asleep or staying asleep.',
                data.q5,
                (v) => setState(() => data.q5 = v),
              ),
              _sliderBlock(
                'I got distracted easily, even during simple tasks.',
                data.q6,
                (v) => setState(() => data.q6 = v),
              ),

              const Spacer(),

              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Quick check before you submit:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Stress (P2): ${data.q4.toStringAsFixed(0)} / 4',
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Sleep  (P2): ${data.q5.toStringAsFixed(0)} / 4',
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Focus  (P2): ${data.q6.toStringAsFixed(0)} / 4',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Back'),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // ✅ Finish -> go Result page, pass data
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MoodResultPage(data: data),
                                  ),
                                );
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
            ],
          ),
        ),
      ),
    );
  }
}
