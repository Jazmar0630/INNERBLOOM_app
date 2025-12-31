// lib/pages/signup_page.dart
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  bool _loading = false;

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  // ✅ default map for your UserPage "activeDays"
  Map<String, bool> _defaultActiveDays() => {
        'mon': false,
        'tue': false,
        'wed': false,
        'thu': false,
        'fri': false,
        'sat': false,
        'sun': false,
      };

  String? _validateUsername(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Enter a username';
    if (s.length < 3) return 'Username too short (min 3)';
    if (s.length > 20) return 'Username too long (max 20)';
    // allow letters, numbers, underscore, dot
    final ok = RegExp(r'^[a-zA-Z0-9._]+$').hasMatch(s);
    if (!ok) return 'Use only letters, numbers, . or _';
    return null;
  }

  String? _validateEmail(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Enter an email';
    final ok = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(s);
    if (!ok) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? v) {
    final s = (v ?? '');
    if (s.length < 6) return 'Min 6 characters';
    return null;
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    if (!agreeToPolicy) {
      _toast("Please agree to privacy policy");
      return;
    }

    final username = _username.text.trim();
    final email = _email.text.trim();
    final password = _password.text.trim();

    setState(() => _loading = true);

    try {
      // 1) Create user in Firebase Auth
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user;
      if (user == null) throw Exception("User creation failed");

      final uid = user.uid;

      // ✅ 2) Update Auth profile displayName (useful for quick reads)
      await user.updateDisplayName(username);

      // 3) Create user document in Firestore (users/{uid})
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
      
        // ✅ store both to avoid mismatch across pages
        'name': username,       // some pages might read "name"
        'username': username,   // some pages might read "username"
        'isNewUser': true,

        'email': email,
        'role': 'user',
        'photoUrl': null,

        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),

        // ✅ IMPORTANT: must exist + have all days for your daily check-in
        'activeDays': _defaultActiveDays(),
        'lastActiveAt': null,
      }, SetOptions(merge: true));

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );

      _toast("Account created ✅ Please login");
    } on FirebaseAuthException catch (e) {
      String msg = "Signup failed";

      if (e.code == 'email-already-in-use') msg = "Email already in use";
      if (e.code == 'invalid-email') msg = "Invalid email";
      if (e.code == 'weak-password') msg = "Password too weak (min 6 chars)";
      if (e.code == 'operation-not-allowed') {
        msg = "Email/Password sign-up is disabled in Firebase Console";
      }
      if (e.code == 'network-request-failed') msg = "No internet connection";

      if (!mounted) return;
      _toast(msg);
    } catch (e) {
      if (!mounted) return;
      _toast("Signup failed");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
                    textInputAction: TextInputAction.next,
                    decoration: _fieldDecoration('Username'),
                    validator: _validateUsername,
                  ),
                  const SizedBox(height: 16),

                  // Email
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: _fieldDecoration('Email'),
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 16),

                  // Password
                  TextFormField(
                    controller: _password,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    decoration: _fieldDecoration('Password'),
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password
                  TextFormField(
                    controller: _confirmPassword,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    decoration: _fieldDecoration('Confirm Password'),
                    validator: (v) {
                      if ((v ?? '').isEmpty) return 'Confirm your password';
                      if (v != _password.text) return 'Passwords do not match';
                      return null;
                    },
                    onFieldSubmitted: (_) => _loading ? null : _signup(),
                  ),
                  const SizedBox(height: 16),

                  // Privacy policy checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: agreeToPolicy,
                        onChanged: _loading
                            ? null
                            : (v) => setState(() => agreeToPolicy = v ?? false),
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
                    onPressed: _loading ? null : _signup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3C5C5A),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'SIGN UP',
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),

                  const SizedBox(height: 20),

                  // Divider "or"
                  Row(
                    children: const [
                      Expanded(child: Divider(color: Colors.white38)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('or', style: TextStyle(color: Colors.white70)),
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

                  // Already have an account
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
                          onTap: _loading
                              ? null
                              : () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const LoginPage()),
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
