import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../mood/onboarding_intro_page.dart';
import '../user/user_page.dart';
import '../relaxation/relaxation_page.dart';
import '../widgets/app_drawer.dart';
import '../widgets/video_player_overlay.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _navIndex = 0;

  void _playVideo(String title, String subtitle, IconData icon, String videoId) {
    VideoPlayerOverlay.show(
      context: context,
      videoId: videoId,
      title: title,
      subtitle: subtitle,
      icon: icon,
    );
  }

  // ✅ Live user document stream (auto updates header when name changes)
  Stream<DocumentSnapshot<Map<String, dynamic>>> _userDocStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      // return an empty stream if not logged in
      return const Stream.empty();
    }
    return FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
  }

  // ✅ Pick the best display name
  String _pickName(Map<String, dynamic>? data) {
    if (data == null) return 'User';

    final name = (data['name'] ?? '').toString().trim();
    if (name.isNotEmpty) return name;

    final username = (data['username'] ?? '').toString().trim();
    if (username.isNotEmpty) return username;

    // fallback: email prefix if no name fields exist
    final email = FirebaseAuth.instance.currentUser?.email ?? '';
    if (email.contains('@')) return email.split('@').first;

    return 'User';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      drawer: const AppDrawer(),
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
              MaterialPageRoute(builder: (_) => const RelaxationPage()),
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
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.psychology_alt_outlined), label: 'Mood'),
          BottomNavigationBarItem(icon: Icon(Icons.self_improvement), label: 'Relaxation'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'User'),
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
                    backgroundImage: AssetImage('assets/avatar_placeholder1.png'),
                  )
                ],
              ),
              const SizedBox(height: 8),

              // ✅ Header: Live username from Firestore
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: _userDocStream(),
                builder: (context, snapshot) {
                  String display = 'User';

                  if (snapshot.hasData && snapshot.data != null && snapshot.data!.exists) {
                    display = _pickName(snapshot.data!.data());
                  } else {
                    // fallback even if doc not created yet
                    display = _pickName(null);
                  }

                  return Text(
                    'Hi, $display!',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  );
                },
              ),

              const SizedBox(height: 6),
              const Text(
                'How do you feel today?',
                style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.2),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _MoodChip(
                    icon: Icons.mood_bad_outlined,
                    label: 'Anxious',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const RelaxationPage(initialCategory: 'Anxiety reliefs'),
                        ),
                      );
                    },
                  ),
                  _MoodChip(
                    icon: Icons.work_outline,
                    label: 'Distracted',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const RelaxationPage(initialCategory: 'Overthinking detox'),
                        ),
                      );
                    },
                  ),
                  _MoodChip(
                    icon: Icons.self_improvement,
                    label: 'Relax',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const RelaxationPage(initialCategory: 'Self-love & confidence'),
                        ),
                      );
                    },
                  ),
                  _MoodChip(
                    icon: Icons.sentiment_very_dissatisfied,
                    label: 'Depressed',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const RelaxationPage(initialCategory: 'Stress & burnout'),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Text('Not sure how do you feel today?', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text("Let's figure it out"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Colors.white24,
                    foregroundColor: Colors.white,
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const OnboardingIntroPage()),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              _RecoCard(
                title: 'Bring your focus back',
                subtitle: 'Listen to our most relaxing songs and gain back your focus',
                buttonText: 'Listen now',
                illustration: Icons.self_improvement,
                onButtonPressed: () {
                  _playVideo(
                    'Bring your focus back',
                    'Listen to our most relaxing songs and gain back your focus',
                    Icons.self_improvement,
                    '9bZkp7q19f0',
                  );
                },
              ),
              const SizedBox(height: 14),
              _RecoCard(
                title: 'Quiet the overthinking',
                subtitle: 'Watch calming visuals and guided talks that help clear your busy mind',
                buttonText: 'Watch now',
                illustration: Icons.weekend_outlined,
                onButtonPressed: () {
                  _playVideo(
                    'Quiet the overthinking',
                    'Watch calming visuals and guided talks that help clear your busy mind',
                    Icons.weekend_outlined,
                    '3JZ_D3ELwOQ',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoodChip extends StatefulWidget {
  const _MoodChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  State<_MoodChip> createState() => _MoodChipState();
}

class _MoodChipState extends State<_MoodChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Column(
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: _isHovered 
                      ? Colors.white.withOpacity(0.25)
                      : Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _isHovered 
                        ? Colors.white.withOpacity(0.6)
                        : Colors.white.withOpacity(0.15),
                    width: _isHovered ? 2.5 : 1.5,
                  ),
                  boxShadow: _isHovered ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ] : [],
                ),
                child: Icon(
                  widget.icon, 
                  color: Colors.white, 
                  size: _isHovered ? 30 : 28,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.label, 
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: _isHovered ? 13 : 12,
                  fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecoCard extends StatelessWidget {
  const _RecoCard({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.illustration,
    required this.onButtonPressed,
  });

  final String title;
  final String subtitle;
  final String buttonText;
  final IconData illustration;
  final VoidCallback onButtonPressed;

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
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.black54, height: 1.3),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: onButtonPressed,
                    icon: const Icon(Icons.play_arrow),
                    label: Text(buttonText),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      backgroundColor: Colors.black.withOpacity(0.06),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
