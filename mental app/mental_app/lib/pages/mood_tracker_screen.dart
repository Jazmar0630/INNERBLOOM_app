import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mood_survey_page_one.dart';

enum Mood { happy, good, moderate, sad, awful }

class MoodSurveyData {
  Mood? selectedMood;                    // from page 1
  final Map<String, double> answers = {}; // slider answers across pages
  MoodSurveyData({this.selectedMood});
}

class MoodTrackerScreen extends StatefulWidget {
   const MoodTrackerScreen({Key? key}) : super(key: key);
   @override
   State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  int? selectedMoodIndex;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<Map<String, dynamic>> moods = [
    {'emoji': '😁', 'label': 'HAPPY', 'value': 5},
    {'emoji': '😊', 'label': 'GOOD', 'value': 4},
    {'emoji': '😐', 'label': 'MODERATE', 'value': 3},
    {'emoji': '☹️', 'label': 'SAD', 'value': 2},
    {'emoji': '😢', 'label': 'AWFUL', 'value': 1},
  ];
// 👇 Paste this helper function here
  Widget _moodEmoji(Mood mood, String emoji, String label) {
    return Column(
      children: [
        InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            final data = MoodSurveyData(selectedMood: mood);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MoodSurveyPageOne(data: data),
              ),
            );
          },
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.teal.withOpacity(0.1),
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 28),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label.toUpperCase(),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Future<void> saveMoodToFirebase() async {
    if (selectedMoodIndex == null) return;

    try {
      await _firestore.collection('moods').add({
        'mood': moods[selectedMoodIndex!]['label'],
        'value': moods[selectedMoodIndex!]['value'],
        'emoji': moods[selectedMoodIndex!]['emoji'],
        'timestamp': FieldValue.serverTimestamp(),
        // Add userId if you have authentication
        // 'userId': FirebaseAuth.instance.currentUser?.uid,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mood saved: ${moods[selectedMoodIndex!]['label']}'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to next screen or reset
      // Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving mood: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF475569), // slate-700
              Color(0xFF64748B), // slate-500
              Color(0xFFCBD5E1), // slate-300
            ],
          ),
        ),
        child: SafeArea(  
          child: Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'HOW DO YOU FEEL TODAY?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),

        // -------- EMOJI STRIP --------
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: [
            _moodEmoji(Mood.happy, '😁', 'Happy'),
            _moodEmoji(Mood.good, '😊', 'Good'),
            _moodEmoji(Mood.moderate, '😐', 'Moderate'),
            _moodEmoji(Mood.sad, '😞', 'Sad'),
            _moodEmoji(Mood.awful, '😭', 'Awful'),
                    ],
            ),
                // -------- EMOJI STRIP END --------
             ],
            ),
          ),  
           
        ),
      ),
    );
  }

  Widget _buildMoodOption(int index) {
    final bool isSelected = selectedMoodIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMoodIndex = index;
        });
      },
      child: AnimatedScale(
        scale: isSelected ? 1.1 : 1.0,
        duration: Duration(milliseconds: 200),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.3)
                    : Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  moods[index]['emoji'],
                  style: TextStyle(fontSize: 28),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              moods[index]['label'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}