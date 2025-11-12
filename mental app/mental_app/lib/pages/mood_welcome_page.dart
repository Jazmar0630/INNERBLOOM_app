 // lib/pages/onboarding_intro_page.dart
import 'package:flutter/material.dart';
import 'mood_tracker_screen.dart'; // <-- your first mood page

class OnboardingIntroPage extends StatelessWidget {
  const OnboardingIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {}, // TODO: open drawer if you have one
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/images/avatar_placeholder.png'),
              // If you don't have an asset yet, comment the line above and uncomment this next line:
              // child: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          const _GradientBg(), // same background as mood pages
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 24),

                // Illustration (use your asset if you have one)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // If you have an illustration: put it in assets/images/meditation.png
                        // and list it in pubspec.yaml, then use:
                        // Image.asset('assets/images/meditation.png', height: 220),
                        Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.self_improvement, size: 120, color: Colors.white),
                        ),
                        const SizedBox(height: 28),
                        const Text(
                          'HELP US TO GET TO KNOW YOU',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            "We wouldn’t know you better than yourself. Help us to get to know you by answering some simple questions",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ANSWER NOW button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MoodTrackerScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF334B57), // deep slate button
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        elevation: 2,
                      ),
                      child: const Text(
                        'ANSWER NOW',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                // Optional bottom icons (purely visual)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      _BottomIcon(icon: Icons.home_rounded),
                      _BottomIcon(icon: Icons.emoji_emotions_rounded),
                      _BottomIcon(icon: Icons.music_note_rounded),
                      _BottomIcon(icon: Icons.person_rounded),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// full-screen gradient reused across pages (same colors as your mood pages)
class _GradientBg extends StatelessWidget {
  const _GradientBg();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
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
    );
  }
}

class _BottomIcon extends StatelessWidget {
  final IconData icon;
  const _BottomIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: Colors.white70, size: 28);
  }
}
