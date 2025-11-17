 // user_page.dart
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'onboarding_intro_page.dart';
import 'relaxation_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int _navIndex = 3; // we are on the User tab

  void _onNavTap(int index) {
   if (index == _navIndex) return;

  setState(() => _navIndex = index);

  switch (index) {
    case 0: // Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
      break;

    case 1: // Figure it out
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingIntroPage()),
      );
      break;

    case 2: // RELAX PAGE 🔥 ADD THIS
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RelaxationPage()),
      );
      break;

    case 3: // User (current page)
      break;
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF25424F),
              Color(0xFFBFB7B3),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar with menu icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        // TODO: open drawer / settings if you want
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // USER AVATAR + NAME ("user")
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 42,
                        backgroundColor: Colors.white.withOpacity(0.85),
                        child: const Icon(
                          Icons.person,
                          size: 48,
                          color: Color(0xFF25424F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'user',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // DAILY CHECK-IN CARD
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Daily check in',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Check in daily and track your progress everyday!',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Row of days
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildDayBubble('Mon', isCompleted: true),
                          _buildDayBubble('Tue'),
                          _buildDayBubble('Wed'),
                          _buildDayBubble('Thur'),
                          _buildDayBubble('Fri'),
                          _buildDayBubble('Sat'),
                          _buildDayBubble('Sun'),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // INSIGHTS CARD
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // title + dropdown
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Insights',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.black26),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.calendar_today,
                                      size: 14, color: Colors.black54),
                                  SizedBox(width: 6),
                                  Text(
                                    'Weekly',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Icon(Icons.arrow_drop_down,
                                      size: 18, color: Colors.black54),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Y-axis labels
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                _MoodLevelLabel('Happy'),
                                _MoodLevelLabel('Good'),
                                _MoodLevelLabel('Moderate'),
                                _MoodLevelLabel('Sad'),
                                _MoodLevelLabel('Awful'),
                              ],
                            ),
                            const SizedBox(width: 12),

                            // chart placeholder
                            Expanded(
                              child: Container(
                                height: 170,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Mood chart placeholder',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black38),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _navIndex,
        onTap: _onNavTap,
        selectedItemColor: const Color(0xFF25424F),
        unselectedItemColor: Colors.grey[500],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology_alt_outlined),
            label: 'Mood',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement),
            label: 'Relaxation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'User',
          ),
        ],
      ),
    );
  }
}

// Small helper widget for the day bubbles
Widget _buildDayBubble(String label, {bool isCompleted = false}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCompleted ? const Color(0xFF25424F) : Colors.white,
          border: Border.all(color: const Color(0xFF25424F)),
        ),
        child: isCompleted
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : null,
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: const TextStyle(fontSize: 11, color: Colors.black87),
      ),
    ],
  );
}

class _MoodLevelLabel extends StatelessWidget {
  final String text;
  const _MoodLevelLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, color: Colors.black54),
      ),
    );
  }
}
