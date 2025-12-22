// lib/pages/signup_page.dart
import 'package:flutter/material.dart';
import 'login_page.dart';
import '../../services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  bool agreeToPolicy = false;

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3C5C5A), Color(0xFFD9D9D9)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Sign Up',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'and start your journey today',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 28),

                  // Username
                  TextFormField(
                    controller: _username,
                    decoration: _fieldDecoration('Username'),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Enter a username' : null,
                  ),
                  const SizedBox(height: 16),

                  // Email
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _fieldDecoration('Email'),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Enter an email';
                      if (!v.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password
                  TextFormField(
                    controller: _password,
                    obscureText: true,
                    decoration: _fieldDecoration('Password'),
                    validator: (v) =>
                        (v == null || v.length < 6) ? 'Min 6 characters' : null,
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password
                  TextFormField(
                    controller: _confirmPassword,
                    obscureText: true,
                    decoration: _fieldDecoration('Confirm Password'),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Confirm your password';
                      }
                      if (v != _password.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Privacy policy checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: agreeToPolicy,
                        onChanged: (v) => setState(() => agreeToPolicy = v!),
                        activeColor: const Color(0xFF3C5C5A),
                      ),
                      const Text(
                        'I have read the ',
                        style: TextStyle(color: Color.fromARGB(179, 0, 0, 0)),
                      ),
                      const Text(
                        'privacy policy',
                        style: TextStyle(
                          color: Color.fromARGB(255, 86, 91, 255),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Sign Up Button
                  ElevatedButton(
              onPressed: () async {
              if (!_formKey.currentState!.validate()) return;

              if (!agreeToPolicy) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please agree to privacy policy")),
                );
                return;
              }

              final result = await AuthService.signup(
                username: _username.text.trim(),
                email: _email.text.trim(),
                password: _password.text.trim(),
              );

              if (result["status"] == "success") {
                Navigator.pop(context); // go back to login
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result["error"] ?? "Signup failed")),
                );
              }
            },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3C5C5A),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'SIGN UP',
                      style: TextStyle(color: Colors.white, letterSpacing: 1),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Divider "or"
                  Row(
                    children: const [
                      Expanded(child: Divider(color: Colors.white38)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child:
                            Text('or', style: TextStyle(color: Colors.white70)),
                      ),
                      Expanded(child: Divider(color: Colors.white38)),
                    ],
                  ),
                  const SizedBox(height: 16),
              
                  // Social row (placeholders)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialButton(Icons.g_mobiledata),
                      const SizedBox(width: 16),
                      _socialButton(Icons.facebook),
                      const SizedBox(width: 16),
                      _socialButton(Icons.apple),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // "Already have an account? Log in" link
                  Center(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      children: [
                        const Text(
                          'Already have an account?',
                          style: TextStyle(color: Color.fromARGB(179, 0, 0, 0)),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginPage()),
                            );
                          },
                          child: const Text(
                            'Log in',
                            style: TextStyle(
                              color: Color.fromARGB(255, 86, 91, 255),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(String hint) {
    return const InputDecoration(
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide.none,
      ),
    ).copyWith(hintText: hint);
  }

  Widget _socialButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white70),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }
}