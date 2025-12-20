import 'package:flutter/material.dart';
import '../mood/onboarding_intro_page.dart';
import '../user/user_page.dart';
import '../relaxation/relaxation_page.dart';
import 'dart:io'; // for exit(0)

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.displayName = 'User!'});
  final String displayName;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      // ⭐ ADD DRAWER HERE
      drawer: _buildAppDrawer(context),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _navIndex,
        onTap: (i) {
          setState(() => _navIndex = i);

          if (i == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const OnboardingIntroPage()),
            );
          } else if (i == 2) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const RelaxationPage  ()),
            );
          } else if (i == 3) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const UserPage()),
            );
          }
        },
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
          )
        ],
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
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [ 
              // Top bar with menu + avatar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      icon: const Icon(Icons.menu, color: Colors.white),
                    ),  
                  ),
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage:
                        AssetImage('assets/avatar_placeholder.png'),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Greeting
              Text(
                'Hi, ${widget.displayName}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'How do you feel today?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 16),

              // Mood chips
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _MoodChip(icon: Icons.mood_bad_outlined, label: 'Anxious'),
                  _MoodChip(icon: Icons.work_outline, label: 'Distracted'),
                  _MoodChip(icon: Icons.self_improvement, label: 'Relax'),
                  _MoodChip(
                      icon: Icons.sentiment_very_dissatisfied,
                      label: 'Depressed'),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                'Not sure how do you feel today?',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text("Let's figure it out"),
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Colors.white24,
                    foregroundColor: Colors.white,
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const OnboardingIntroPage()),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              _RecoCard(
                title: 'Bring your focus back',
                subtitle:
                    'Listen to our most relaxing songs and gain back your focus',
                buttonText: 'Listen now',
                illustration: Icons.self_improvement,
              ),
              const SizedBox(height: 14),
              _RecoCard(
                title: 'Quiet the overthinking',
                subtitle:
                    'Watch calming visuals and guided talks that help clear your busy mind',
                buttonText: 'Watch now',
                illustration: Icons.weekend_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// ⭐ DRAWER WIDGET
// ---------------------------------------------------------
Widget _buildAppDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(color: Color(0xFF3C5C5A)),
          child: Text(
            'InnerBloom',
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: const Text('Help & Support'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: const Text('Privacy Policy'),
          onTap: () {},
        ),

        const Divider(),      

        ListTile(
          leading: const Icon(Icons.exit_to_app, color: Colors.red),
          title: const Text(
            'Exit App',
            style: TextStyle(color: Colors.red),
          ),
          onTap: () {
            exit(0);
          },
        ),
      ],
    ),
  );
}
      
// ---------------------------------------------------------

class _MoodChip extends StatelessWidget {
  const _MoodChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.10),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white24),
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}

class _RecoCard extends StatelessWidget {
  const _RecoCard({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.illustration,
  });

  final String title;
  final String subtitle;
  final String buttonText;
  final IconData illustration;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black12,
            ),
            child: Icon(illustration, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.black54, height: 1.3)),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.play_arrow),
                    label: Text(buttonText),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      backgroundColor: Colors.black.withOpacity(0.06),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      foregroundColor: Colors.black87,
                    ),
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
      