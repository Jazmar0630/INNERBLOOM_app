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
                    width: 50,
                    height: 50,
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? const Color(0xFF25424F) : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    options[index],
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 24),
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
              _tickableBlock(
                'I feel overwhelmed by tasks or responsibilities today.',
                data.q4,
                (v) => setState(() => data.q4 = v),
              ),
              _tickableBlock(
                'I had trouble falling asleep or staying asleep.',
                data.q5,
                (v) => setState(() => data.q5 = v),
              ),
              _tickableBlock(
                'I got distracted easily, even during simple tasks.',
                data.q6,
                (v) => setState(() => data.q6 = v),
              ),

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
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}