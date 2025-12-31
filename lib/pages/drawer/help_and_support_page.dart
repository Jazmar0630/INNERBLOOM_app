import 'dart:io';
import 'package:flutter/material.dart';
import '../mood/onboarding_intro_page.dart';
import '../relaxation/relaxation_page.dart';
import '../user/user_page.dart';
import '../home/home_page.dart';
import '../widgets/app_drawer.dart';
import 'settings_page.dart';
import 'privacy_policy.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  int _navIndex = 3;
  final TextEditingController _enquiryController = TextEditingController();

  @override
  void dispose() {
    _enquiryController.dispose();
    super.dispose();
  }

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
                      builder: (context) => HoverMenuButton(
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ), //HMB
                    ),

                    const Expanded(
                      child: Center(
                        child: Text(
                          'HELP & SUPPORT',
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
                    // Contact Form Section
                    const Text(
                      "Can't find what you want?",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Submit your enquiries here, or contact us at',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'E-mail: innerbloom.support@gmail.com',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Call: 03-5000 5000',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Enquiry Text Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _enquiryController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          hintText: 'Type here',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Submit Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle submit
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Enquiry submitted!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3C5C5A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // FAQs Section
                    const Text(
                      'FAQs',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _FAQTile(
                      question: 'What is this app for?',
                      answer: 'InnerBloom is a mental wellness app designed to help you manage stress, anxiety, and improve your overall mental health through guided exercises and relaxation techniques.',
                    ),
                    const SizedBox(height: 12),
                    _FAQTile(
                      question: 'Is this app a replacement for therapy?',
                      answer: 'No, this app is not a replacement for professional therapy. It is designed to complement your mental health journey and provide tools for self-care. Please consult with a mental health professional for serious concerns.',
                    ),
                    const SizedBox(height: 12),
                    _FAQTile(
                      question: 'How do I track my mood?',
                      answer: 'Navigate to the Mood tab and follow the mood check-in process. You can log your feelings daily and track patterns over time.',
                    ),
                    const SizedBox(height: 12),
                    _FAQTile(
                      question: 'Where can I find relaxing videos and sounds?',
                      answer: 'Visit the Relaxation tab to access our library of calming videos, sounds, and guided meditation sessions tailored to your needs.',
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            onTap: () {
              Navigator.pop(context);
              // Already on Help & Support page
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

class _FAQTile extends StatefulWidget {
  const _FAQTile({
    required this.question,
    required this.answer,
  });

  final String question;
  final String answer;

  @override
  State<_FAQTile> createState() => _FAQTileState();
}

class _FAQTileState extends State<_FAQTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.black54,
                  ),
                ],
              ),
              if (_isExpanded) ...[
                const SizedBox(height: 12),
                Text(
                  widget.answer,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ],
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