import 'dart:io';
import 'package:flutter/material.dart';
import '../drawer/settings_page.dart';
import '../drawer/help_and_support_page.dart';
import '../drawer/privacy_policy.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF3C5C5A)),
            child: Center(
              child: Text(
                'InnerBloom',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
          const Divider(height:40),
          const SizedBox(height: 5),
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
  }
}


// ========================================
// HOW TO USE IN YOUR PAGES
// ========================================

// STEP 1: Add this import at the top of each page
// import '../widgets/app_drawer.dart';

// STEP 2: In your Scaffold, replace drawer: _buildAppDrawer(context) with:
// drawer: const AppDrawer(),

// STEP 3: Remove the entire _buildAppDrawer() method from each page