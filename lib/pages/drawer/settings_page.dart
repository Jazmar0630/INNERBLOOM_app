import 'dart:io';
import 'package:flutter/material.dart';
import '../mood/onboarding_intro_page.dart';
import '../relaxation/relaxation_page.dart';
import '../user/user_page.dart';
import '../home/home_page.dart';
import '../widgets/app_drawer.dart';
import 'help_and_support_page.dart';
import 'privacy_policy.dart';

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
      drawer: const AppDrawer(), // ADDED DRAWER
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        icon: const Icon(Icons.menu, color: Colors.white),
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
                    // Profile Section
                    _HoverProfileSection(),
                    const SizedBox(height: 8),
                    Divider(color: Colors.white.withOpacity(1.5), thickness: 1),
                    const SizedBox(height: 16),

                    // GENERAL Section
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
                    ),
                    const SizedBox(height: 24),

                    // FEEDBACK Section
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*// DRAWER WIDGET
  Widget _buildAppDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF3C5C5A)),
            child: Text(
              'InnerBloom',
              style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // Already on Settings page
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HelpSupportPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text('Exit App', style: TextStyle(color: Colors.red)),
            onTap: () {
              exit(0);
            },
          ),
        ],
      ),
    );
  }*/
}

class _SettingsTile extends StatefulWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  State<_SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<_SettingsTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
          child: Row(
            children: [
              Icon(
                widget.icon, 
                color: _isHovered ? Colors.white : Colors.white.withOpacity(0.9), 
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 16,
                    color: _isHovered ? Colors.white : Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right, 
                color: _isHovered ? Colors.white.withOpacity(0.7) : Colors.white.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HoverProfileSection extends StatefulWidget {
  @override
  State<_HoverProfileSection> createState() => _HoverProfileSectionState();
}

class _HoverProfileSectionState extends State<_HoverProfileSection> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        padding: const EdgeInsets.all(16),
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
                    'Ahmad Syawqi',
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
                      color: _isHovered ? Colors.white.withOpacity(0.8) : Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right, 
              color: _isHovered ? Colors.white.withOpacity(0.8) : Colors.white.withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }
}