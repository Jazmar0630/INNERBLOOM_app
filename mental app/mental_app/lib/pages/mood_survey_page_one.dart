 import 'package:flutter/material.dart';
import '_shared_background.dart';
import 'mood_survey_data.dart';
import 'mood_survey_page_two.dart';

class MoodSurveyPageOne extends StatefulWidget {
  final MoodSurveyData data;
  const MoodSurveyPageOne({super.key, required this.data});

  @override
  State<MoodSurveyPageOne> createState() => _MoodSurveyPageOneState();
}

class _MoodSurveyPageOneState extends State<MoodSurveyPageOne> {
  Widget _sliderBlock(String question, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        Slider(value: value, min: 0, max: 4, divisions: 4, label: value.round().toString(), onChanged: onChanged),
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
      appBar: AppBar(title: const Text('Mood Survey — Page 1')),
      body: SharedBg(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _sliderBlock('How stressed do you feel?', widget.data.q1, (v) => setState(() => widget.data.q1 = v)),
              _sliderBlock('How well did you sleep?', widget.data.q2, (v) => setState(() => widget.data.q2 = v)),
              _sliderBlock('How focused are you today?', widget.data.q3, (v) => setState(() => widget.data.q3 = v)),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MoodSurveyPageTwo(data: widget.data)),
                    );
                  },
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
