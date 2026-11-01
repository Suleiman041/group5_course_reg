import 'package:flutter/material.dart';

import '../services/storage_service.dart';
import '../theme.dart';
import '../widgets/watermark.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

/// First screen: logo, title, and a clean login card (Apple style).
/// StatefulWidget because what the user types changes over time.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _regNoController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _error;
  bool _hidePassword = true;

  // EVENT HANDLER (Lecture 3): runs when the Log In button is pressed.
  Future<void> _login() async {
    final regNo = _regNoController.text.trim().toUpperCase();
    final password = _passwordController.text;
    if (regNo.isEmpty || password.isEmpty) {
      setState(() => _error = 'Enter your reg number and password.');
      return;
    }
    final student = await StorageService.login(regNo, password);
    if (!mounted) return; // the screen may have closed while we waited
    if (student == null) {
      setState(() => _error = 'Wrong reg number or password.');
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen(student: student)),
    );
  }

  @override
  void dispose() {
    _regNoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Watermark(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  const LogoBadge(size: 96),
                  const SizedBox(height: 20),
                  const Text('Course Registration',
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold, color: label, letterSpacing: -0.5)),
                  const SizedBox(height: 4),
                  const Text('Bayero University, Kano',
                      style: TextStyle(fontSize: 16, color: secondaryLabel)),
                  const SizedBox(height: 32),
                  // Both fields inside one white card, separated by a thin line (iOS style).
                  GroupCard(
                    child: Column(
                      children: [
                        TextField(
                          controller: _regNoController,
                          decoration: fieldStyle('Reg Number', Icons.badge_outlined),
                        ),
                        rowDivider,
                        TextField(
                          controller: _passwordController,
                          obscureText: _hidePassword, // hides the password with dots
                          decoration: fieldStyle('Password', Icons.lock_outline).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off,
                                  color: secondaryLabel, size: 20),
                              onPressed: () => setState(() => _hidePassword = !_hidePassword),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(_error!, style: const TextStyle(color: danger)),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: FilledButton(
                        style: primaryButton(), onPressed: _login, child: const Text('Log In')),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignupScreen()),
                    ),
                    child: const Text('New student? Create an account',
                        style: TextStyle(color: accent, fontSize: 15)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
