import 'package:flutter/material.dart';

import '../data/course_catalog.dart';
import '../models/course.dart';
import '../models/registration.dart';
import '../models/student.dart';
import '../services/storage_service.dart';
import '../theme.dart';
import 'course_form_screen.dart';
import 'gpa_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';

/// Main screen: greeting, a units summary card, and the course list.
/// Tap the + to add a course, tap the tick to drop it.
class HomeScreen extends StatefulWidget {
  final Student student;
  const HomeScreen({super.key, required this.student});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Registration _registration;
  late final List<Course> _available;

  @override
  void initState() {
    super.initState();
    _available = coursesFor(widget.student.level, widget.student.semester);
    _registration = Registration.forCourses(_available);
    _loadSaved();
  }

  // Reload courses saved last time, so registration survives closing the app.
  Future<void> _loadSaved() async {
    final codes = await StorageService.loadRegistration(widget.student);
    if (!mounted) return;
    setState(() {
      for (final code in codes) {
        final course = courseByCode(code);
        if (course != null) _registration.add(course);
      }
    });
  }

  Future<void> _save() => StorageService.saveRegistration(
        widget.student,
        _registration.courses.map((c) => c.code).toList(),
      );

  // Add or drop, depending on whether the course is already registered.
  void _toggle(Course course) {
    if (_registration.contains(course)) {
      setState(() => _registration.drop(course));
    } else {
      final error = _registration.add(course);
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
        return;
      }
      setState(() {});
    }
    _save();
  }

  void _openCourseForm() {
    if (!_registration.canSubmit) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_registration.statusMessage)));
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CourseFormScreen(student: widget.student, courses: _registration.courses),
      ),
    );
  }

  void _openGpa() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GpaScreen(student: widget.student, courses: _registration.courses),
      ),
    );
  }

  void _openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProfileScreen(student: widget.student)),
    );
  }

  void _logout() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  // White card: big unit number, progress bar, and status message.
  Widget _summaryCard() {
    final units = _registration.totalUnits;
    final ok = _registration.canSubmit;
    final barColor = ok ? success : warning;
    return GroupCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$units',
                  style: const TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: label, height: 1)),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('of ${_registration.maxUnits} units',
                    style: const TextStyle(fontSize: 16, color: secondaryLabel)),
              ),
              const Spacer(),
              Icon(ok ? Icons.check_circle : Icons.info, color: barColor, size: 28),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (units / _registration.maxUnits).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: separator,
              color: barColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(_registration.statusMessage, style: const TextStyle(fontSize: 14, color: secondaryLabel)),
        ],
      ),
    );
  }

  // One course row: units badge, code and title, and an add/drop icon.
  Widget _courseRow(Course course) {
    final added = _registration.contains(course);
    return ListTile(
      onTap: () => _toggle(course),
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: added ? accent : background,
        child: Text('${course.units}',
            style: TextStyle(fontWeight: FontWeight.bold, color: added ? Colors.white : accent)),
      ),
      title: Text(course.code, style: const TextStyle(fontWeight: FontWeight.w600, color: label)),
      subtitle: Text(course.title, style: const TextStyle(color: secondaryLabel)),
      trailing: Icon(
        added ? Icons.check_circle : Icons.add_circle_outline,
        color: added ? success : accent,
        size: 28,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.student;
    return Scaffold(
      appBar: appleAppBar('', actions: [
        IconButton(icon: const Icon(Icons.person_outline), tooltip: 'Profile', onPressed: _openProfile),
        IconButton(icon: const Icon(Icons.calculate_outlined), tooltip: 'GPA Calculator', onPressed: _openGpa),
        IconButton(icon: const Icon(Icons.logout), tooltip: 'Log out', onPressed: _logout),
      ]),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          LargeTitle('Hello, ${s.name.split(' ').first}',
              subtitle: '${s.regNo}  ·  ${s.level} Level  ·  ${s.semester == 1 ? 'First' : 'Second'} Semester'),
          _summaryCard(),
          const SectionHeader('Available courses'),
          if (_available.isEmpty)
            const GroupCard(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('No courses added for this level and semester yet.')),
            )
          else
            GroupCard(
              child: Column(
                children: [
                  for (var i = 0; i < _available.length; i++) ...[
                    if (i > 0) rowDivider,
                    _courseRow(_available[i]),
                  ],
                ],
              ),
            ),
        ],
      ),
      // Full-width button pinned at the bottom, like iOS.
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton(
            style: primaryButton(),
            onPressed: _openCourseForm,
            child: const Text('View Course Form'),
          ),
        ),
      ),
    );
  }
}
