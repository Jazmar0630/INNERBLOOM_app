import 'package:flutter/material.dart';
import 'pages/auth/welcome_page.dart';
 

 

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
      home: const WelcomePage(),

    );
  }
}
