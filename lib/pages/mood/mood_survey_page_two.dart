import 'package:flutter/material.dart';
import '../model/mood_survey_data.dart';
import '../mood/mood_result.dart';

class MoodSurveyPageTwo extends StatefulWidget {
  final MoodSurveyData data;
  const MoodSurveyPageTwo({super.key, required this.data});

  @override
  State<MoodSurveyPageTwo> createState() => _MoodSurveyPageTwoState();
}

class _MoodSurveyPageTwoState extends State<MoodSurveyPageTwo> {
  final List<String> _labels = ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'];
  final List<IconData> _overwhelmedIcons = [
    Icons.check_circle_outline,
    Icons.task_alt,
    Icons.pending_actions,
    Icons.warning_amber,
    Icons.error_outline,
  ];
  final List<IconData> _sleepIcons = [
    Icons.bedtime,
    Icons.nights_stay,
    Icons.dark_mode,
    Icons.light_mode,
    Icons.wb_sunny,
  ];
  final List<IconData> _focusIcons = [
    Icons.center_focus_strong,
    Icons.center_focus_weak,
    Icons.blur_circular,
    Icons.blur_on,
    Icons.scatter_plot,
  ];

  Widget _optionButton(String label, IconData icon, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected 
                ? Colors.white.withOpacity(0.25)
                : Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected 
                  ? Colors.white.withOpacity(0.6)
                  : Colors.white.withOpacity(0.15),
              width: isSelected ? 2.5 : 1.5,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ] : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: isSelected ? 36 : 32,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSelected ? 13 : 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _questionBlock(
    String question,
    double value,
    ValueChanged<double> onChanged,
    List<IconData> icons,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: List.generate(5, (index) {
              return _optionButton(
                _labels[index],
                icons[index],
                value.round() == index,
                () => onChanged(index.toDouble()),
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Survey'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF3C5C5A),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3C5C5A), Color(0xFF9DA5A9)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Progress indicator
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Almost done!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Just a few more questions',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 32),
                      _questionBlock(
                        'I feel overwhelmed by tasks or responsibilities today.',
                        data.q4,
                        (v) => setState(() => data.q4 = v),
                        _overwhelmedIcons,
                      ),
                      _questionBlock(
                        'I had trouble falling asleep or staying asleep.',
                        data.q5,
                        (v) => setState(() => data.q5 = v),
                        _sleepIcons,
                      ),
                      _questionBlock(
                        'I got distracted easily, even during simple tasks.',
                        data.q6,
                        (v) => setState(() => data.q6 = v),
                        _focusIcons,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white, width: 2),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF3C5C5A),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'Finish',
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
            ],
          ),
        ),
      ),
    );
  }
}