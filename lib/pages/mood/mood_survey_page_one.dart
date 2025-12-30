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
  final List<String> _labels = ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'];
  final List<IconData> _stressIcons = [
    Icons.sentiment_very_satisfied,
    Icons.sentiment_satisfied,
    Icons.sentiment_neutral,
    Icons.sentiment_dissatisfied,
    Icons.sentiment_very_dissatisfied,
  ];
  final List<IconData> _sleepIcons = [
    Icons.bedtime_off,
    Icons.nights_stay_outlined,
    Icons.nights_stay,
    Icons.hotel,
    Icons.king_bed,
  ];
  final List<IconData> _focusIcons = [
    Icons.blur_on,
    Icons.remove_red_eye_outlined,
    Icons.visibility,
    Icons.center_focus_strong,
    Icons.my_location,
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
<<<<<<< HEAD
              _tickableBlock('How stressed do you feel?', widget.data.q1, (v) => setState(() => widget.data.q1 = v)),
              _tickableBlock('How well did you sleep?', widget.data.q2, (v) => setState(() => widget.data.q2 = v)),
              _tickableBlock('How focused are you today?', widget.data.q3, (v) => setState(() => widget.data.q3 = v)),
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
=======
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
>>>>>>> 4e6c98acf007cf2b1604accd9f76a2da60216771
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
    return Scaffold(
      appBar: AppBar(
        //title: const Text('Mood Survey'),
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
                          color: Colors.white.withOpacity(0.3),
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
                        'HOW ARE YOU FEELING TODAY?',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Select the option that best describes you',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 32),
                      _questionBlock(
                        'How stressed do you feel?',
                        widget.data.q1,
                        (v) => setState(() => widget.data.q1 = v),
                        _stressIcons,
                      ),
                      _questionBlock(
                        'How well did you sleep?',
                        widget.data.q2,
                        (v) => setState(() => widget.data.q2 = v),
                        _sleepIcons,
                      ),
                      _questionBlock(
                        'How focused are you today?',
                        widget.data.q3,
                        (v) => setState(() => widget.data.q3 = v),
                        _focusIcons,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MoodSurveyPageTwo(data: widget.data),
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
                      'NEXT',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
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