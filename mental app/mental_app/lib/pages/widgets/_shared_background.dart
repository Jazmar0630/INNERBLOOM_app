 import 'package:flutter/material.dart';

class SharedBg extends StatelessWidget {
  final Widget child;
  const SharedBg({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF394B5F), Color(0xFF9FB0C1)],
          stops: [0.0, 0.65],
        ),
      ),
      child: SafeArea(child: child),
    );
  }
}
