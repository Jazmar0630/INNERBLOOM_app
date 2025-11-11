 import 'package:flutter/material.dart';
import 'mood_survey_page_two.dart';
import 'mood_tracker_screen.dart'; // provides Mood & MoodSurveyData

class MoodSurveyPageOne extends StatefulWidget {
  final MoodSurveyData data;
  const MoodSurveyPageOne({super.key, required this.data});

  @override
  State<MoodSurveyPageOne> createState() => _MoodSurveyPageOneState();
}

class _MoodSurveyPageOneState extends State<MoodSurveyPageOne> {
  double q1 = 2, q2 = 2, q3 = 2; // 0..4 = Never..Always

  Widget _sliderBlock(String question, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        Slider(value: value, min: 0, max: 4, divisions: 4, onChanged: onChanged),
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('MOOD TRACKING', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          const _GradientBg(), // full-screen gradient
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  _sliderBlock('Do you often feel restless or on edge?', q1, (v) => setState(() => q1 = v)),
                  _sliderBlock('Have you been feeling down, hopeless, or sad most days?', q2, (v) => setState(() => q2 = v)),
                  _sliderBlock('Do you often feel overwhelmed by responsibilities?', q3, (v) => setState(() => q3 = v)),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FloatingActionButton(
                      heroTag: 'next1',
                      onPressed: () {
                        widget.data.answers['restless'] = q1;
                        widget.data.answers['down'] = q2;
                        widget.data.answers['overwhelmed'] = q3;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => MoodSurveyPageTwo(data: widget.data)),
                        );
                      },
                      child: const Icon(Icons.arrow_forward),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// simple full-screen gradient
class _GradientBg extends StatelessWidget {
  const _GradientBg();
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF475569), Color(0xFF64748B), Color(0xFFCBD5E1)],
          ),
        ),
      );
}
