 import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum Mood { happy, okay, sad, angry, calm }

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Mood? _selectedMood;

  String _emojiFor(Mood m) {
    switch (m) {
      case Mood.happy:
        return '😊';
      case Mood.okay:
        return '😐';
      case Mood.sad:
        return '😢';
      case Mood.angry:
        return '😠';
      case Mood.calm:
        return '😌';
    }
  }

  Future<void> saveMoodToFirebase() async {
    final messenger = ScaffoldMessenger.of(context); // capture BEFORE await
    try {
      await _firestore.collection('moods').add({
        'mood': _selectedMood?.name,
        'emoji': _selectedMood == null ? null : _emojiFor(_selectedMood!),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      messenger.showSnackBar(const SnackBar(content: Text('Mood saved')));
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text('Error saving mood: $e')));
    }
  }

  Widget _moodEmoji(Mood mood, String emoji, String label) {
    final isSelected = _selectedMood == mood;
    return GestureDetector(
      onTap: () => setState(() => _selectedMood = mood),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 2,
                color: isSelected ? Colors.blue : Colors.grey,
              ),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 36)),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mood Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                // The const Row cannot call non-const methods, so we build below
              ],
            ),
            // Build the emojis (not const because it depends on state)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _moodEmoji(Mood.happy, '😊', 'Happy'),
                _moodEmoji(Mood.okay, '😐', 'Okay'),
                _moodEmoji(Mood.sad, '😢', 'Sad'),
                _moodEmoji(Mood.angry, '😠', 'Angry'),
                _moodEmoji(Mood.calm, '😌', 'Calm'),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedMood == null ? null : saveMoodToFirebase,
                child: const Text('Save mood'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
