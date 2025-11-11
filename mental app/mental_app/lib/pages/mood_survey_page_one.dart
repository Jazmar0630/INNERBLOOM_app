import 'package:flutter/material.dart';
import 'mood_survey_page_two.dart';
import 'mood_tracker_screen.dart'; // for Mood enum & MoodSurveyData (or import your model file)

class MoodSurveyPageOne extends StatefulWidget {
  final MoodSurveyData data;
  const MoodSurveyPageOne({super.key, required this.data});

  @override
  State<MoodSurveyPageOne> createState() => _MoodSurveyPageOneState();
}

class _MoodSurveyPageOneState extends State<MoodSurveyPageOne> {
  // local slider values (0–4 = Never..Always)
  double q1 = 2;
  double q2 = 2;
  double q3 = 2;

  Widget _sliderBlock(String question, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        Slider(
          value: value,
          min: 0, max: 4, divisions: 4,
          label: const ['Never','Rarely','Sometimes','Often','Always'][0],
          onChanged: onChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Never'), Text('Rarely'), Text('Sometimes'), Text('Often'), Text('Always'),
          ],
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MOOD TRACKING')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _sliderBlock('Do you often feel restless or on edge?', q1, (v)=>setState(()=>q1=v)),
            _sliderBlock('Have you been feeling down, hopeless, or sad most days?', q2, (v)=>setState(()=>q2=v)),
            _sliderBlock('Do you often feel overwhelmed by responsibilities?', q3, (v)=>setState(()=>q3=v)),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton(
                heroTag: 'next1',
                onPressed: () {
                  // store answers into the shared data bag
                  widget.data.answers['restless'] = q1;
                  widget.data.answers['down'] = q2;
                  widget.data.answers['overwhelmed'] = q3;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MoodSurveyPageTwo(data: widget.data),
                    ),
                  );
                },
                child: const Icon(Icons.arrow_forward),
              ),
            )
          ],
        ),
      ),
    );
  }
}
