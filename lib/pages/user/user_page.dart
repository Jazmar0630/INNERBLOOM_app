// lib/pages/user/user_page.dart
import 'dart:async';
import 'dart:io'; // exit(0)

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../home/home_page.dart';
import '../mood/onboarding_intro_page.dart';
import '../relaxation/relaxation_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int _navIndex = 3;
  String? _uid;
  StreamSubscription<User?>? _authSub;
  String? _initError;

  @override
  void initState() {
    super.initState();
    _uid = FirebaseAuth.instance.currentUser?.uid;
    
    if (_uid != null) {
      _autoCheckIn();
    }

    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (!mounted) return;
      setState(() {
        _uid = user?.uid;
        _initError = null;
      });
      if (_uid != null) {
        _autoCheckIn();
      }
    });
  }

  void _autoCheckIn() async {
    if (_uid == null) return;
    
    final today = _weekdayKey(DateTime.now());
    
    try {
      await FirebaseFirestore.instance.collection('users').doc(_uid!).set({
        'username': 'user',
        'activeDays.$today': true,
        'lastActiveAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      // Silent fail
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  String _weekdayKey(DateTime dt) {
    const keys = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
    return keys[dt.weekday - 1];
  }

  Future<void> _markTodayActive() async {
    if (_uid == null) return;

    final today = _weekdayKey(DateTime.now());

    try {
      await FirebaseFirestore.instance.collection('users').doc(_uid!).update({
        'activeDays.$today': true,
        'lastActiveAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      await FirebaseFirestore.instance.collection('users').doc(_uid!).set({
        'username': 'user',
        'createdAt': FieldValue.serverTimestamp(),
        'activeDays': {
          'mon': today == 'mon',
          'tue': today == 'tue', 
          'wed': today == 'wed',
          'thu': today == 'thu',
          'fri': today == 'fri',
          'sat': today == 'sat',
          'sun': today == 'sun',
        },
        'lastActiveAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> _userDocStream() {
    if (_uid == null) return const Stream.empty();
    return FirebaseFirestore.instance.collection('users').doc(_uid!).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _moodStream() {
    if (_uid == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection('users')
        .doc(_uid!)
        .collection('moods')
        .orderBy('createdAt', descending: true)
        .limit(7)
        .snapshots();
  }

  Future<void> _addSampleMood() async {
    if (_uid == null) return;
    
    final moods = [1, 2, 3, 4, 5];
    final randomMood = (moods..shuffle()).first;
    
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid!)
        .collection('moods')
        .add({
      'mood': randomMood,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  void _onNavTap(int index) {
    if (index == _navIndex) return;

    setState(() => _navIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingIntroPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RelaxationPage()),
        );
        break;
      case 3:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      drawer: _buildAppDrawer(context),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF25424F), Color(0xFFBFB7B3)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 42,
                        backgroundColor: Color(0xDDFFFFFF),
                        child: Icon(
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
                      const SizedBox(height: 6),
                      Text(
                        'UID: ${_uid ?? "-"}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                      if (_initError != null) ...[
                        const SizedBox(height: 10),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 720),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red),
                          ),
                          child: Text(
                            'Firestore error:\n$_initError',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () async {
                    if (_uid == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please login first')),
                      );
                      return;
                    }
                    try {
                      await _markTodayActive();
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Checked in for today ✅')),
                      );
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Check-in failed: $e')),
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                        if (_uid == null)
                          const Text(
                            'Please login first',
                            style: TextStyle(color: Colors.black54),
                          )
                        else
                          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            stream: _userDocStream(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text(
                                  'Firestore error: ${snapshot.error}',
                                  style: const TextStyle(color: Colors.red, fontSize: 12),
                                );
                              }
                              if (!snapshot.hasData) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: List.generate(7, (i) => 
                                    _buildDayBubble(['Mon','Tue','Wed','Thu','Fri','Sat','Sun'][i])
                                  ),
                                );
                              }
                              final doc = snapshot.data!;
                              if (!doc.exists) {
                                return const Text(
                                  'No user doc found',
                                  style: TextStyle(color: Colors.black54, fontSize: 12),
                                );
                              }
                              final data = doc.data() ?? {};
                              final raw = data['activeDays'];
                              final Map<String, bool> activeDays = (raw is Map)
                                  ? Map<String, bool>.from(
                                      raw.map((k, v) => MapEntry(k.toString(), v == true)),
                                    )
                                  : {};
                              bool isActive(String key) => activeDays[key] == true;
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildDayBubble('Mon', isCompleted: isActive('mon')),
                                  _buildDayBubble('Tue', isCompleted: isActive('tue')),
                                  _buildDayBubble('Wed', isCompleted: isActive('wed')),
                                  _buildDayBubble('Thu', isCompleted: isActive('thu')),
                                  _buildDayBubble('Fri', isCompleted: isActive('fri')),
                                  _buildDayBubble('Sat', isCompleted: isActive('sat')),
                                  _buildDayBubble('Sun', isCompleted: isActive('sun')),
                                ],
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.black26),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.calendar_today, size: 14, color: Colors.black54),
                                SizedBox(width: 6),
                                Text(
                                  'Weekly',
                                  style: TextStyle(fontSize: 12, color: Colors.black54),
                                ),
                                Icon(Icons.arrow_drop_down, size: 18, color: Colors.black54),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
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
                                color: const Color(0xFFF2F2F2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                stream: _moodStream(),
                                builder: (context, snapshot) {
                                  if (_uid == null) {
                                    return const Center(
                                      child: Text(
                                        'Please login first',
                                        style: TextStyle(fontSize: 12, color: Colors.black38),
                                      ),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Text(
                                          'Mood error:\n${snapshot.error}',
                                          style: const TextStyle(fontSize: 12, color: Colors.red),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  }
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: Text(
                                        'Loading...',
                                        style: TextStyle(fontSize: 12, color: Colors.black38),
                                      ),
                                    );
                                  }
                                  if (snapshot.data!.docs.isEmpty) {
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'No mood data yet',
                                            style: TextStyle(fontSize: 12, color: Colors.black38),
                                          ),
                                          const SizedBox(height: 8),
                                          ElevatedButton(
                                            onPressed: _addSampleMood,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFF25424F),
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            ),
                                            child: const Text(
                                              'Add Sample',
                                              style: TextStyle(fontSize: 10, color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  final moods = snapshot.data!.docs
                                      .map((d) {
                                        final v = d.data()['mood'];
                                        return (v is int) ? v : 0;
                                      })
                                      .toList()
                                      .reversed
                                      .toList();
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: moods.map((mood) {
                                      final safeMood = mood.clamp(0, 5);
                                      return Container(
                                        width: 14,
                                        height: safeMood * 30.0,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF25424F),
                                          borderRadius: BorderRadius.circular(6),
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
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
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
