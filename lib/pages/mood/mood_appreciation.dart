import 'package:flutter/material.dart';
import '../home/home_page.dart';

class MoodAppreciationPage extends StatefulWidget {
  const MoodAppreciationPage({super.key});

  @override
  State<MoodAppreciationPage> createState() => _MoodAppreciationPageState();
}

class _MoodAppreciationPageState extends State<MoodAppreciationPage> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3C5C5A), Color(0xFFD9D9D9)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  const SizedBox(height: 20),

                  // CIRCLE ICON
                  Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.self_improvement, size: 100, color: Colors.white),
                  ),

                  const SizedBox(height: 32),

                  const SizedBox(height: 30),

                  // Description text with "Thank You" in bold
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        height: 1.4,
                      ),
                      children: [
                        TextSpan(
                          text: 'Thank You',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: " for checking in. You've taken a brave step today. A small progress is still a progress. We're so proud of you!",
                        ),
                      ],
                    ),
                  ),  

                  const Spacer(),

                  // Back to home Button with hover effect
                  MouseRegion(
                    onEnter: (_) => setState(() => _isHovered = true),
                    onExit: (_) => setState(() => _isHovered = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isHovered 
                              ? const Color(0xFF4A6B68) 
                              : const Color(0xFF3C5C5A),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: _isHovered ? 8 : 4,
                        ),
                        child: Text(
                          'BACK TO HOME',
                          style: TextStyle(
                            fontSize: 16,
                            color: _isHovered ? Colors.white : Colors.white.withOpacity(0.95),
                            letterSpacing: 1.2,
                            fontWeight: _isHovered ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}