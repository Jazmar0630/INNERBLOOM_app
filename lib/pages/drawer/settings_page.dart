import 'dart:io';
import 'package:flutter/material.dart';

import '../mood/onboarding_intro_page.dart';
import '../relaxation/relaxation_page.dart';
import '../user/user_page.dart';
import '../home/home_page.dart';
import '../widgets/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _navIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      extendBody: true,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _navIndex,
        onTap: (i) {
          setState(() => _navIndex = i);

          if (i == 0) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          } else if (i == 1) {
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
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                      Builder(
                      builder: (context) => HoverMenuButton(
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),

                    const Expanded(
                      child: Center(
                        child: Text(
                          'SETTINGS',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  children: [
                    // Profile Section (with hover)
                    _HoverProfileSection(
                      onTap: () {
                        // TODO: Navigate to edit profile page
                      },
                    ),
                    const SizedBox(height: 8),
                    Divider(color: Colors.white.withOpacity(0.25), thickness: 1),
                    const SizedBox(height: 16),

                    // GENERAL
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 12),
                      child: Text(
                        'GENERAL',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.9),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.person_outline,
                      title: 'Account',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.logout,
                      title: 'Logout',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.delete_outline,
                      title: 'Delete account',
                      onTap: () {},
                      danger: true,
                    ),
                    const SizedBox(height: 24),

                    // FEEDBACK
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 12),
                      child: Text(
                        'FEEDBACK',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.9),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.warning_amber_outlined,
                      title: 'Report a bug',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.feedback_outlined,
                      title: 'Send feedback',
                      onTap: () {},
                    ),

                    const SizedBox(height: 18),
                    Divider(color: Colors.white.withOpacity(0.25), thickness: 1),
                    const SizedBox(height: 10),

                    // Optional: Exit App
                    _SettingsTile(
                      icon: Icons.exit_to_app,
                      title: 'Exit App',
                      onTap: () => exit(0),
                      danger: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatefulWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool danger;

  @override
  State<_SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<_SettingsTile> {
  bool _isHovered = false;
  bool _isPressed = false;

  // Hover makes container darker, pressed makes it slightly more dark
  Color _tileBgColor() {
    if (_isPressed) return Colors.black.withOpacity(0.20);
    if (_isHovered) return Colors.black.withOpacity(0.12);
    return Colors.white.withOpacity(0.06);
  }

  @override
  Widget build(BuildContext context) {
    final baseTextColor = widget.danger ? Colors.redAccent : Colors.white.withOpacity(0.92);
    final hoverTextColor = widget.danger ? Colors.redAccent.withOpacity(0.95) : Colors.white;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _isPressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapCancel: () => setState(() => _isPressed = false),
        onTapUp: (_) => setState(() => _isPressed = false),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(14),
          splashColor: Colors.white.withOpacity(0.08),
          highlightColor: Colors.white.withOpacity(0.05),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 130),
            curve: Curves.easeOut,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            decoration: BoxDecoration(
              color: _tileBgColor(), // ✅ darker on hover
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _isHovered ? Colors.white.withOpacity(0.22) : Colors.white.withOpacity(0.14),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  size: 24,
                  color: _isHovered ? hoverTextColor : baseTextColor,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 16,
                      color: _isHovered ? hoverTextColor : baseTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: _isHovered
                      ? Colors.white.withOpacity(0.75)
                      : Colors.white.withOpacity(0.50),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HoverProfileSection extends StatefulWidget {
  const _HoverProfileSection({this.onTap});
  final VoidCallback? onTap;

  @override
  State<_HoverProfileSection> createState() => _HoverProfileSectionState();
}

class _HoverProfileSectionState extends State<_HoverProfileSection> {
  bool _isHovered = false;
  String _username = 'Loading...';

@override
void initState() {
  super.initState();
  _loadUsername();
}

Future<void> _loadUsername() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get();

  if (doc.exists) {
    setState(() {
      _username = doc.data()?['username'] ?? 'User';
    });
  }
}



  @override
  Widget build(BuildContext context) {
    final bg = _isHovered ? Colors.black.withOpacity(0.12) : Colors.white.withOpacity(0.06);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.white.withOpacity(0.08),
        highlightColor: Colors.white.withOpacity(0.05),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 130),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bg, // ✅ darker on hover
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered ? Colors.white.withOpacity(0.22) : Colors.white.withOpacity(0.14),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/avatar_placeholder1.png'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text(
                        _username,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _isHovered ? Colors.white : Colors.white.withOpacity(0.95),
                        ),
                      ),
                      
                    const SizedBox(height: 4),
                    Text(
                      'Edit personal details',
                      style: TextStyle(
                        fontSize: 14,
                        color: _isHovered
                            ? Colors.white.withOpacity(0.85)
                            : Colors.white.withOpacity(0.70),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: _isHovered ? Colors.white.withOpacity(0.85) : Colors.white.withOpacity(0.70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HoverMenuButton extends StatefulWidget {
  final VoidCallback onPressed;

  const HoverMenuButton({super.key, required this.onPressed});

  @override
  State<HoverMenuButton> createState() => _HoverMenuButtonState();
}


class _HoverMenuButtonState extends State<HoverMenuButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: _hover ? Colors.white.withOpacity(0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: _hover
              ? [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.25),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: IconButton(
          onPressed: widget.onPressed,
          icon: Icon(
            Icons.menu,
            color: _hover ? Colors.white : Colors.white.withOpacity(0.85),
          ),
        ),
      ),
    );
  }
}