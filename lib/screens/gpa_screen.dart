import 'package:flutter/material.dart';

import '../models/course.dart';
import '../models/gpa_calculator.dart';
import '../models/student.dart';
import '../services/storage_service.dart';
import '../theme.dart';

/// GPA calculator: pick a grade for each registered course.
/// The ring (like Apple's activity rings) fills up as GPA rises.
class GpaScreen extends StatefulWidget {
  final Student student;
  final List<Course> courses;
  const GpaScreen({super.key, required this.student, required this.courses});

  @override
  State<GpaScreen> createState() => _GpaScreenState();
}

class _GpaScreenState extends State<GpaScreen> {
  Map<String, String> _grades = {}; // course code -> grade

  @override
  void initState() {
    super.initState();
    StorageService.loadGrades(widget.student).then((g) {
      if (mounted) setState(() => _grades = g);
    });
  }

  double get _gpa {
    final map = <Course, String>{};
    for (final c in widget.courses) {
      final g = _grades[c.code];
      if (g != null) map[c] = g;
    }
    return GpaCalculator.calculate(map);
  }

  void _setGrade(Course course, String grade) {
    setState(() => _grades[course.code] = grade);
    StorageService.saveGrades(widget.student, _grades);
  }

  // White card with a ring that fills to GPA / 5.
  Widget _gpaRing() {
    final gpa = _gpa;
    final graded = widget.courses.where((c) => _grades[c.code] != null).length;
    return GroupCard(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        children: [
          SizedBox(
            width: 170,
            height: 170,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 170,
                  height: 170,
                  child: CircularProgressIndicator(
                    value: (gpa / 5).clamp(0.0, 1.0),
                    strokeWidth: 14,
                    backgroundColor: separator,
                    color: accent,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(gpa.toStringAsFixed(2),
                        style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: label)),
                    const Text('out of 5.00', style: TextStyle(color: secondaryLabel)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('$graded of ${widget.courses.length} courses graded',
              style: const TextStyle(color: secondaryLabel)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appleAppBar('GPA Calculator'),
      body: widget.courses.isEmpty
          ? const Center(child: Text('Register some courses first.'))
          : ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                _gpaRing(),
                const SectionHeader('Grades'),
                GroupCard(
                  child: Column(
                    children: [
                      for (var i = 0; i < widget.courses.length; i++) ...[
                        if (i > 0) rowDivider,
                        _gradeRow(widget.courses[i]),
                      ],
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _gradeRow(Course c) => ListTile(
        title: Text(c.code, style: const TextStyle(fontWeight: FontWeight.w600, color: label)),
        subtitle: Text('${c.title}  ·  ${c.units} units', style: const TextStyle(color: secondaryLabel)),
        trailing: DropdownButton<String>(
          hint: const Text('Grade', style: TextStyle(color: accent)),
          value: _grades[c.code],
          underline: const SizedBox(),
          items: GpaCalculator.gradePoints.keys
              .map((g) => DropdownMenuItem(
                    value: g,
                    child: Text(g, style: const TextStyle(fontWeight: FontWeight.w600, color: accent)),
                  ))
              .toList(),
          onChanged: (g) {
            if (g != null) _setGrade(c, g);
          },
        ),
      );
}
