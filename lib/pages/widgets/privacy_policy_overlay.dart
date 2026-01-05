import 'package:flutter/material.dart';

class PrivacyPolicyOverlay extends StatefulWidget {
  final VoidCallback onClose;

  const PrivacyPolicyOverlay({
    super.key,
    required this.onClose,
  });

  @override
  State<PrivacyPolicyOverlay> createState() => _PrivacyPolicyOverlayState();
}

class _PrivacyPolicyOverlayState extends State<PrivacyPolicyOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _overlayController;
  late Animation<Offset> _overlayOffset;
  double _dragOffset = 0;

  @override
  void initState() {
    super.initState();
    _overlayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _overlayOffset = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _overlayController, curve: Curves.easeOut));

    _overlayController.forward();
  }

  void _close() {
    _overlayController.reverse().then((_) {
      if (!mounted) return;
      widget.onClose();
    });
  }

  @override
  void dispose() {
    _overlayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: _close,
        child: Container(
          color: Colors.black54,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: _overlayOffset,
              child: GestureDetector(
                onTap: () {},
                onVerticalDragUpdate: (details) {
                  setState(() => _dragOffset += details.delta.dy);
                },
                onVerticalDragEnd: (_) {
                  if (_dragOffset > 100) {
                    _close();
                  } else {
                    setState(() => _dragOffset = 0);
                  }
                },
                child: Transform.translate(
                  offset: Offset(0, _dragOffset),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 32,
                    height: MediaQuery.of(context).size.height * 0.85,
                    margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(2.5),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Header with close button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Privacy Policy',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3C5C5A),
                                ),
                              ),
                              IconButton(
                                onPressed: _close,
                                icon: const Icon(Icons.close, color: Color(0xFF3C5C5A)),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),
                        const Divider(),

                        // Scrollable content
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.all(20),
                            children: [
                              Text(
                                'Updated on April 23, 2025',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 24),

                              const Text(
                                '1. Introduction',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'We respect your privacy and are committed to protecting your personal information. This Privacy Policy explains what data we collect, how we use it, and your choices regarding your information when you use our app.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 24),

                              const Text(
                                '2. Information We Collect',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'We may collect the following types of information:',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Personal Information: Name, email address, Phone Number',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Mood & Mental Health Data: Mood check-ins, journal entries, and questionnaire responses (used only to personalize your experience)',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Usage Data: How you interact with the app features (e.g., relaxation content watched or listened to)',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Device Information: Device type, operating system, crash reports (to improve the app)',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 24),

                              const Text(
                                '3. How We Use Your Information',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'We use your data to:',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Personalize content (like mood insights and relaxation suggestions)',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 24),

                              const Text(
                                '4. Data Security',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'We implement industry-standard security measures to protect your data. However, no method of transmission over the internet is 100% secure.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 24),

                              const Text(
                                '5. Your Rights',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'You have the right to:\n• Access your personal data\n• Request correction of inaccurate data\n• Request deletion of your account and data\n• Opt-out of certain data collection',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 24),

                              const Text(
                                '6. Contact Us',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'If you have any questions about this Privacy Policy, please contact us at:\n\nEmail: innerbloom.support@gmail.com\nPhone: 03-5000 5000',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}