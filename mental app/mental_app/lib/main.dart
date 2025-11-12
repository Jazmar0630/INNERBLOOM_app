import 'package:flutter/material.dart';
import 'pages/home_page.dart'; // 👈 make sure you have this file (your mood homepage)
import 'pages/onboarding_intro_page.dart'; // 👈 make sure you have this file

void main() {
  runApp(const InnerBloomApp());
}

class InnerBloomApp extends StatelessWidget {
  const InnerBloomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InnerBloom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      home: const HomePage(), // 👈 start directly on your homepage
    );
  }
}
