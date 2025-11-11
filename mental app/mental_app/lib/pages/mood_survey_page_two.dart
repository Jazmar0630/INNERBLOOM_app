import 'package:flutter/material.dart';
import 'mood_tracker_screen.dart'; // for MoodSurveyData (or import your model file)
 

class MoodSurveyPageTwo extends StatefulWidget {
  final MoodSurveyData data;
  const MoodSurveyPageTwo({super.key, required this.data});

  @override
  State<MoodSurveyPageTwo> createState() => _MoodSurveyPageTwoState();
}

class _MoodSurveyPageTwoState extends State<MoodSurveyPageTwo> {
  double q4 = 2;
  double q5 = 2;
  double q6 = 2;

  Widget _sliderBlock(String question, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        Slider(
          value: value,
          min: 0, max: 4, divisions: 4,
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

  void _finish() {
    widget.data.answers['detached'] = q4;
    widget.data.answers['out_of_control'] = q5;
    widget.data.answers['disconnected'] = q6;

    // TODO: Save to Firebase/SharedPreferences here if you like.
    // For now we just pop back with result:
    Navigator.popUntil(context, (route) => route.isFirst);
    // Optionally show a snackbar:
    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Responses saved')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MOOD TRACKING')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _sliderBlock('Do you feel detached from others or emotionally numb?', q4, (v)=>setState(()=>q4=v)),
            _sliderBlock('Do your emotions feel out of control or unpredictable lately?', q5, (v)=>setState(()=>q5=v)),
            _sliderBlock('Do you ever feel disconnected from yourself or your surroundings?', q6, (v)=>setState(()=>q6=v)),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton.extended(
                heroTag: 'finish',
                icon: const Icon(Icons.check),
                label: const Text('Finish'),
                onPressed: _finish,
              ),
            )
          ],
        ),
      ),
    );
  }
}
