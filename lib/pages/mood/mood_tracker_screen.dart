import 'package:flutter/material.dart';
import 'mood_survey_page_one.dart';
import '../model/mood_survey_data.dart';

enum Mood { happy, okay, sad, angry, calm }

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  Mood? _selectedMood;

  IconData _iconFor(Mood m) {
    switch (m) {
      case Mood.happy:
        return Icons.sentiment_very_satisfied;
      case Mood.okay:
        return Icons.sentiment_neutral;
      case Mood.sad:
        return Icons.sentiment_dissatisfied;
      case Mood.angry:
        return Icons.sentiment_very_dissatisfied;
      case Mood.calm:
        return Icons.sentiment_satisfied;
    }
  }

  String _labelFor(Mood m) {
    switch (m) {
      case Mood.happy:
        return 'Happy';
      case Mood.okay:
        return 'Okay';
      case Mood.sad:
        return 'Sad';
      case Mood.angry:
        return 'Angry';
      case Mood.calm:
        return 'Calm';
    }
  }

  void _selectMood(Mood m) => setState(() => _selectedMood = m);

  @override
  Widget build(BuildContext context) {
    final calmWidth = MediaQuery.of(context).size.width * 0.45;

    return Scaffold(
      appBar: AppBar(
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'HOW ARE YOU FEELING RIGHT NOW?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select the mood that best describes you',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 24),

                // cards area
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: MoodHoverCard(
                                icon: _iconFor(Mood.happy),
                                label: _labelFor(Mood.happy),
                                selected: _selectedMood == Mood.happy,
                                onTap: () => _selectMood(Mood.happy),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: MoodHoverCard(
                                icon: _iconFor(Mood.okay),
                                label: _labelFor(Mood.okay),
                                selected: _selectedMood == Mood.okay,
                                onTap: () => _selectMood(Mood.okay),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: MoodHoverCard(
                                icon: _iconFor(Mood.sad),
                                label: _labelFor(Mood.sad),
                                selected: _selectedMood == Mood.sad,
                                onTap: () => _selectMood(Mood.sad),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: MoodHoverCard(
                                icon: _iconFor(Mood.angry),
                                label: _labelFor(Mood.angry),
                                selected: _selectedMood == Mood.angry,
                                onTap: () => _selectMood(Mood.angry),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Center(
                          child: SizedBox(
                            width: calmWidth,
                            child: MoodHoverCard(
                              icon: _iconFor(Mood.calm),
                              label: _labelFor(Mood.calm),
                              selected: _selectedMood == Mood.calm,
                              onTap: () => _selectMood(Mood.calm),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // next button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedMood == null
                        ? null
                        : () {
                            final data = MoodSurveyData();

                            // ✅ OPTIONAL: if MoodSurveyData has a field, you can store it
                            // data.mood = _selectedMood.toString().split('.').last;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MoodSurveyPageOne(data: data),
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF3C5C5A),
                      disabledBackgroundColor: Colors.white.withOpacity(0.30),
                      disabledForegroundColor: Colors.white.withOpacity(0.50),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ✅ Reusable hover + selected mood card
class MoodHoverCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const MoodHoverCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.selected,
  });

  @override
  State<MoodHoverCard> createState() => _MoodHoverCardState();
}

class _MoodHoverCardState extends State<MoodHoverCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.selected || _hover;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: active
                ? Colors.white.withOpacity(0.25) // brighter on hover/selected
                : Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: active
                  ? Colors.white.withOpacity(0.60)
                  : Colors.white.withOpacity(0.15),
              width: active ? 2.5 : 1.5,
            ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.20),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: AnimatedScale(
            duration: const Duration(milliseconds: 220),
            scale: active ? 1.02 : 1.0, // subtle pop on hover
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  color: Colors.white,
                  size: active ? 48 : 44,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: active ? 15 : 14,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
