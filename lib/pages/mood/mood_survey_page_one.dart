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
            return _HoverAnswerOption(
              index: index,
              isSelected: isSelected,
              label: options[index],
              onTap: () => onChanged(index.toDouble()),
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

class _HoverAnswerOption extends StatefulWidget {
  final int index;
  final bool isSelected;
  final String label;
  final VoidCallback onTap;

  const _HoverAnswerOption({
    required this.index,
    required this.isSelected,
    required this.label,
    required this.onTap,
  });

  @override
  State<_HoverAnswerOption> createState() => _HoverAnswerOptionState();
}

class _HoverAnswerOptionState extends State<_HoverAnswerOption> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isSelected ? Colors.white : Colors.transparent,
                border: Border.all(
                  color: _isHovered ? Colors.white : Colors.white.withOpacity(0.8),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  (widget.index + 1).toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: widget.isSelected 
                        ? const Color(0xFF25424F) 
                        : _isHovered ? Colors.white : Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 13,
                color: widget.isSelected 
                    ? Colors.white 
                    : _isHovered ? Colors.white : Colors.white70,
                fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}