// lib/widgets/app_drawer.dart
import 'dart:io';
import 'package:flutter/material.dart';

import '../drawer/settings_page.dart';
import '../drawer/help_and_support_page.dart';
import '../drawer/privacy_policy.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static const _bg = Color(0xFF3C5C5A);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: _bg,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            const _DrawerHeader(),

            const SizedBox(height: 6),

            HoverDrawerTile(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
            ),

            HoverDrawerTile(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HelpSupportPage()),
                );
              },
            ),

            HoverDrawerTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
                );
              },
            ),

            const SizedBox(height: 12),
            const Divider(color: Colors.white24, height: 24),

            HoverDrawerTile(
              icon: Icons.exit_to_app,
              title: 'Exit App',
              isDanger: true,
              onTap: () => exit(0),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'InnerBloom',
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Your calm space 🌿',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

/// ✅ Brighter hover effect tile (Web/Desktop)
class HoverDrawerTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDanger;

  const HoverDrawerTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  State<HoverDrawerTile> createState() => _HoverDrawerTileState();
}

class _HoverDrawerTileState extends State<HoverDrawerTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final iconColor = widget.isDanger ? Colors.redAccent : Colors.white;
    final textColor = widget.isDanger ? Colors.redAccent : Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            // ✅ BRIGHTER on hover (white overlay)
            color: _hover
                ? Colors.white.withOpacity(0.18)
                : Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _hover
                  ? Colors.white.withOpacity(0.35)
                  : Colors.white.withOpacity(0.12),
            ),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.10),
                      blurRadius: 14,
                      spreadRadius: 1,
                    )
                  ]
                : [],
          ),
          child: ListTile(
            leading: Icon(widget.icon, color: iconColor),
            title: Text(
              widget.title,
              style: TextStyle(
                color: textColor,
                fontWeight: _hover ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            // reduce extra padding
            dense: true,
            visualDensity: const VisualDensity(horizontal: -2, vertical: -1),
            onTap: widget.onTap,
          ),
        ),
      ),
    );
  }
}
