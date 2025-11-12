 import 'package:flutter/material.dart';
import 'pages/onboarding_intro_page.dart';
import 'pages/mood_tracker_screen.dart';
import 'pages/mood_survey_page_one.dart';
import 'pages/mood_survey_page_two.dart';
import 'pages/mood_survey_data.dart';

void main() {
  runApp(const InnerBloomApp());
}

class InnerBloomApp extends StatelessWidget {
  const  InnerBloomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InnerBloom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      home: const HomePage(), // ✅ start on HomePage
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OnboardingIntroPage()),
            );
          },
          child: const Text('Go to Wellbeing Intro'),
        ),
      ),
    );
  }
}
