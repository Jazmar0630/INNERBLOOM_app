import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'MOOD TRACKING',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Main Content
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'HOW DO YOU FEEL TODAY?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 60),

                          // Mood Options
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              moods.length,
                              (index) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: _buildMoodOption(index),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Floating Next Button
              Positioned(
                bottom: 32,
                right: 32,
                child: FloatingActionButton(
                  onPressed: selectedMoodIndex != null ? saveMoodToFirebase : null,
                  backgroundColor: selectedMoodIndex != null
                      ? Color(0xFF475569)
                      : Color(0xFF94A3B8),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
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