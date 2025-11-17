import 'package:flutter/material.dart';
import '_shared_background.dart';
import 'mood_tracker_screen.dart';

class OnboardingIntroPage extends StatelessWidget {
  const OnboardingIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SharedBg(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // Icon circle
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.self_improvement, size: 100, color: Colors.white),
            ),
            const SizedBox(height: 32),
            const Text(
              'HELP US TO GET TO KNOW YOU',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 1.1),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'We wouldn’t know you better than yourself. Help us get to know you by answering some simple questions.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25424F),
                    shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(48)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MoodTrackerScreen()),
                    );
                  },
                  child: const Text('ANSWER NOW', style: TextStyle(fontSize: 16, letterSpacing: 1.0)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
