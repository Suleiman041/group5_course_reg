import 'package:flutter/material.dart';

import '../models/student.dart';
import '../services/storage_service.dart';
import '../theme.dart';
import 'home_screen.dart';

/// View and edit the student's profile: name, department,
/// level, semester and password. The reg number can't change.
class ProfileScreen extends StatefulWidget {
  final Student student;
  const ProfileScreen({super.key, required this.student});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _deptController;
  final _newPasswordController = TextEditingController();
  late int _level;
  late int _semester;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Start the form with the student's current details.
    _nameController = TextEditingController(text: widget.student.name);
    _deptController = TextEditingController(text: widget.student.department);
    _level = widget.student.level;
    _semester = widget.student.semester;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _deptController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  // Initials for the round avatar, e.g. "Suleiman Arabi" -> "SA".
  String get _initials {
    final parts = widget.student.name.trim().split(RegExp(r'\s+'));
    return parts.take(2).map((p) => p.isEmpty ? '' : p[0].toUpperCase()).join();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final dept = _deptController.text.trim();
    final newPassword = _newPasswordController.text;
    if (name.isEmpty || dept.isEmpty) {
      setState(() => _error = 'Name and department cannot be empty.');
      return;
    }
    if (newPassword.isNotEmpty && newPassword.length < 6) {
      setState(() => _error = 'New password must be at least 6 characters.');
      return;
    }
    final updated = widget.student.copyWith(
      name: name,
      department: dept,
      level: _level,
      semester: _semester,
      // Only change the password if a new one was typed.
      passwordHash: newPassword.isEmpty ? null : StorageService.hashPassword(newPassword),
    );
    await StorageService.updateStudent(updated);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated.')));
    // Reopen Home with the updated details, so the right courses show.
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen(student: updated)),
      (route) => false,
    );
  }

  Widget _readOnlyRow(IconData icon, String name, String value) => ListTile(
        leading: Icon(icon, color: secondaryLabel, size: 20),
        title: Text(name, style: const TextStyle(color: label)),
        trailing: Text(value, style: const TextStyle(color: secondaryLabel, fontSize: 15)),
      );

  Widget _pickerRow(IconData icon, String name, Widget picker) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: secondaryLabel, size: 20),
            const SizedBox(width: 16),
            Expanded(child: Text(name, style: const TextStyle(fontSize: 16, color: label))),
            picker,
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final s = widget.student;
    return Scaffold(
      appBar: appleAppBar('Profile'),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          // Avatar with initials, name and reg number.
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: accent,
                  child: Text(_initials,
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                const SizedBox(height: 12),
                Text(s.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: label)),
                Text(s.regNo, style: const TextStyle(color: secondaryLabel)),
              ],
            ),
          ),
          const SectionHeader('Personal'),
          GroupCard(
            child: Column(children: [
              TextField(controller: _nameController, decoration: fieldStyle('Full Name', Icons.person_outline)),
              rowDivider,
              _readOnlyRow(Icons.badge_outlined, 'Reg Number', s.regNo),
              rowDivider,
              TextField(
                  controller: _deptController, decoration: fieldStyle('Department', Icons.apartment_outlined)),
            ]),
          ),
          const SectionHeader('Academic'),
          GroupCard(
            child: Column(children: [
              _pickerRow(
                Icons.stairs_outlined,
                'Level',
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
                Icons.event_outlined,
                'Semester',
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
          const Padding(
            padding: EdgeInsets.fromLTRB(32, 6, 32, 0),
            child: Text('Courses are saved separately for each level and semester.',
                style: TextStyle(fontSize: 13, color: secondaryLabel)),
          ),
          const SectionHeader('Security'),
          GroupCard(
            child: TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: fieldStyle('New password (leave blank to keep)', Icons.lock_outline),
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 12, 32, 0),
              child: Text(_error!, style: const TextStyle(color: danger)),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: FilledButton(style: primaryButton(), onPressed: _save, child: const Text('Save Changes')),
          ),
        ],
      ),
    );
  }
}
