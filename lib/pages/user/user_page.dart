// user_page.dart
import 'package:flutter/material.dart';
import '../home/home_page.dart';
import '../mood/onboarding_intro_page.dart';
import '../relaxation/relaxation_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io'; // for exit(0)

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int _navIndex = 3; // we are on the User tab
  String? _uid;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (!mounted) return;

      setState(() => _uid = user?.uid);

      if (user != null) {
        _markTodayActive();
      }
    });
  }

  // ---------------------------
  // Daily check-in logic
  // ---------------------------
  String _weekdayKey(DateTime dt) {
    const keys = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
    return keys[dt.weekday - 1];
  }

  Future<void> _markTodayActive() async {
    if (_uid == null) return;

    final today = _weekdayKey(DateTime.now());

    await FirebaseFirestore.instance.collection('users').doc(_uid).set({
      'activeDays.$today': true,
      'lastActiveAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // ---------------------------
  // Mood chart stream (last 7 moods)
  // ---------------------------
  Stream<QuerySnapshot<Map<String, dynamic>>> _moodStream() {
    if (_uid == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection('moods')
        .orderBy('createdAt', descending: false)
        .limit(7)
        .snapshots();
  }

  // ---------------------------
  // Bottom nav
  // ---------------------------
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

      case 1: // Mood / onboarding
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingIntroPage()),
        );
        break;

      case 2: // Relaxation
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RelaxationPage()),
        );
        break;

      case 3: // User (current)
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      // ✅ Drawer
      drawer: _buildAppDrawer(context),

      // Gradient background
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
                // Top bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Avatar + name
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

                // ✅ DAILY CHECK-IN CARD (click to check-in)
                InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () async {
                    if (_uid == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please login first')),
                      );
                      return;
                    }

                    await _markTodayActive();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Checked in for today ✅')),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
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

                        _uid == null
                            ? const Text(
                                'Please login first',
                                style: TextStyle(color: Colors.black54),
                              )
                            : StreamBuilder<
                                DocumentSnapshot<Map<String, dynamic>>>(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(_uid)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const SizedBox();
                                  }

                                  final data = snapshot.data!.data() ?? {};
                                  final activeDays =
                                      (data['activeDays'] as Map?)
                                              ?.cast<String, dynamic>() ??
                                          {};

                                  bool isActive(String key) =>
                                      activeDays[key] == true;

                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildDayBubble('Mon',
                                          isCompleted: isActive('mon')),
                                      _buildDayBubble('Tue',
                                          isCompleted: isActive('tue')),
                                      _buildDayBubble('Wed',
                                          isCompleted: isActive('wed')),
                                      _buildDayBubble('Thu',
                                          isCompleted: isActive('thu')),
                                      _buildDayBubble('Fri',
                                          isCompleted: isActive('fri')),
                                      _buildDayBubble('Sat',
                                          isCompleted: isActive('sat')),
                                      _buildDayBubble('Sun',
                                          isCompleted: isActive('sun')),
                                    ],
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // INSIGHTS CARD
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
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
                              child: const Row(
                                children: [
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

                        // Y-axis labels + mood chart
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

                            Expanded(
                              child: Container(
                                height: 170,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: StreamBuilder<
                                    QuerySnapshot<Map<String, dynamic>>>(
                                  stream: _moodStream(),
                                  builder: (context, snapshot) {
                                    if (_uid == null) {
                                      return const Center(
                                        child: Text(
                                          'Please login first',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black38),
                                        ),
                                      );
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }

                                    if (!snapshot.hasData ||
                                        snapshot.data!.docs.isEmpty) {
                                      return const Center(
                                        child: Text(
                                          'No mood data yet',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black38),
                                        ),
                                      );
                                    }

                                    final moods = snapshot.data!.docs
                                        .map((d) =>
                                            (d.data()['mood'] ?? 0) as int)
                                        .toList();

                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: moods.map((mood) {
                                        final safeMood = mood.clamp(0, 5);
                                        return Container(
                                          width: 14,
                                          height: safeMood * 30.0,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF25424F),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
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

      // Bottom navigation bar
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

// ---------------------------------------------------------
// Drawer widget
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
          title: const Text('Exit App', style: TextStyle(color: Colors.red)),
          onTap: () => exit(0),
        ),
      ],
    ),
  );
}

// Day bubble widget
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
