import 'package:flutter/material.dart';
import '../widgets/_shared_background.dart';
import '../model/mood_survey_data.dart';
import 'mood_survey_page_two.dart';

class MoodSurveyPageOne extends StatefulWidget {
  final MoodSurveyData data;
  const MoodSurveyPageOne({super.key, required this.data});

  @override
  State<MoodSurveyPageOne> createState() => _MoodSurveyPageOneState();
}

class _MoodSurveyPageOneState extends State<MoodSurveyPageOne> {
  Widget _tickableBlock(String question, double value, ValueChanged<double> onChanged) {
    const options = ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            final isSelected = value.round() == index;
            return GestureDetector(
              onTap: () => onChanged(index.toDouble()),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? Colors.white : Colors.transparent,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? const Color(0xFF25424F) : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    options[index],
                    style: TextStyle(
                      fontSize: 13,
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 48),
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
              _tickableBlock('How stressed do you feel?', widget.data.q1, (v) => setState(() => widget.data.q1 = v)),
              const SizedBox(height: 48),
              _tickableBlock('How well did you sleep?', widget.data.q2, (v) => setState(() => widget.data.q2 = v)),
              const SizedBox(height: 48),
              _tickableBlock('How focused are you today?', widget.data.q3, (v) => setState(() => widget.data.q3 = v)),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF3C5C5A),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MoodSurveyPageTwo(data: widget.data)),
                    );
                  },
                  child: const Text(
                    'NEXT',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
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