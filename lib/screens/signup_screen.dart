import 'package:flutter/material.dart';

import '../models/student.dart';
import '../services/storage_service.dart';
import '../theme.dart';

/// Create an account, laid out like an iOS settings form:
/// grouped white cards with grey section headers.
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _regNoController = TextEditingController();
  final _deptController = TextEditingController();
  final _passwordController = TextEditingController();
  int _level = 500;
  int _semester = 1;
  String? _error;

  Future<void> _signUp() async {
    final name = _nameController.text.trim();
    final regNo = _regNoController.text.trim().toUpperCase();
    final dept = _deptController.text.trim();
    final password = _passwordController.text;

    // Input checks before saving anything.
    if (name.isEmpty || regNo.isEmpty || dept.isEmpty) {
      setState(() => _error = 'Fill in every field.');
      return;
    }
    if (password.length < 6) {
      setState(() => _error = 'Password must be at least 6 characters.');
      return;
    }

    final student = Student(
      regNo: regNo,
      name: name,
      department: dept,
      level: _level,
      semester: _semester,
      passwordHash: StorageService.hashPassword(password),
    );
    final error = await StorageService.signUp(student);
    if (!mounted) return;
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account created. You can now log in.')),
    );
    Navigator.pop(context); // back to the login screen
  }

  @override
  void dispose() {
    _nameController.dispose();
    _regNoController.dispose();
    _deptController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // A row with a label on the left and a dropdown on the right.
  Widget _pickerRow(String text, IconData icon, Widget picker) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Icon(icon, color: secondaryLabel, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 16, color: label))),
            picker,
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appleAppBar('Create Account'),
      body: ListView(
        children: [
          const SectionHeader('Personal'),
          GroupCard(
            child: Column(children: [
              TextField(controller: _nameController, decoration: fieldStyle('Full Name', Icons.person_outline)),
              rowDivider,
              TextField(controller: _regNoController, decoration: fieldStyle('Reg Number', Icons.badge_outlined)),
              rowDivider,
              TextField(
                  controller: _deptController, decoration: fieldStyle('Department', Icons.apartment_outlined)),
            ]),
          ),
          const SectionHeader('Academic'),
          GroupCard(
            child: Column(children: [
              _pickerRow(
                'Level',
                Icons.stairs_outlined,
                DropdownButton<int>(
                  value: _level,
                  underline: const SizedBox(),
                  items: [100, 200, 300, 400, 500]
                      .map((l) => DropdownMenuItem(value: l, child: Text('$l')))
                      .toList(),
                  onChanged: (v) => setState(() => _level = v!),
                ),
              ),
              rowDivider,
              _pickerRow(
                'Semester',
                Icons.event_outlined,
                DropdownButton<int>(
                  value: _semester,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('First')),
                    DropdownMenuItem(value: 2, child: Text('Second')),
                  ],
                  onChanged: (v) => setState(() => _semester = v!),
                ),
              ),
            ]),
          ),
          const SectionHeader('Security'),
          GroupCard(
            child: TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: fieldStyle('Password (min 6 characters)', Icons.lock_outline),
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 12, 32, 0),
              child: Text(_error!, style: const TextStyle(color: danger)),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
            child: FilledButton(style: primaryButton(), onPressed: _signUp, child: const Text('Create Account')),
          ),
        ],
      ),
    );
  }
}
