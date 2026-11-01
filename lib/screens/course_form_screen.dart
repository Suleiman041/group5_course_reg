import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../models/course.dart';
import '../models/student.dart';
import '../services/pdf_service.dart';
import '../theme.dart';
import '../widgets/watermark.dart';

/// The final course form: university header, student details,
/// and a table of registered courses with the total units.
class CourseFormScreen extends StatelessWidget {
  final Student student;
  final List<Course> courses;
  const CourseFormScreen({super.key, required this.student, required this.courses});

  Widget _detail(String name, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(width: 110, child: Text(name, style: const TextStyle(color: secondaryLabel))),
            Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600, color: label))),
          ],
        ),
      );

  // Opens the print dialog, which also offers "Save as PDF".
  Future<void> _print() async {
    final fileName = 'Course_Form_${student.regNo.replaceAll('/', '_')}.pdf';
    await Printing.layoutPdf(
      name: fileName,
      onLayout: (_) => PdfService.buildCourseForm(student, courses),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = courses.fold<int>(0, (sum, c) => sum + c.units);
    final now = DateTime.now();
    final date = '${now.day}/${now.month}/${now.year}';
    return Scaffold(
      appBar: appleAppBar('Course Form', actions: [
        IconButton(icon: const Icon(Icons.print_outlined), tooltip: 'Print', onPressed: _print),
      ]),
      // Full-width print button pinned at the bottom.
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton.icon(
            style: primaryButton(),
            onPressed: _print,
            icon: const Icon(Icons.picture_as_pdf_outlined),
            label: const Text('Print / Save as PDF'),
          ),
        ),
      ),
      body: Watermark(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            GroupCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(child: LogoBadge(size: 64)),
                  const SizedBox(height: 12),
                  const Text('Bayero University, Kano',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: label)),
                  const Text('Student Course Registration Form',
                      textAlign: TextAlign.center, style: TextStyle(color: secondaryLabel)),
                  const Divider(height: 32, color: separator),
                  _detail('Name', student.name),
                  _detail('Reg No', student.regNo),
                  _detail('Department', student.department),
                  _detail('Level', '${student.level}'),
                  _detail('Semester', student.semester == 1 ? 'First' : 'Second'),
                  _detail('Date', date),
                  const SizedBox(height: 18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Table(
                      border: const TableBorder(
                        horizontalInside: BorderSide(color: separator),
                      ),
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(4),
                        2: FlexColumnWidth(1.3),
                      },
                      children: [
                        const TableRow(
                          decoration: BoxDecoration(color: background),
                          children: [
                            _Cell('Code', header: true),
                            _Cell('Title', header: true),
                            _Cell('Units', header: true),
                          ],
                        ),
                        for (final c in courses)
                          TableRow(children: [_Cell(c.code), _Cell(c.title), _Cell('${c.units}')]),
                        TableRow(
                          decoration: const BoxDecoration(color: Color(0xFFEAF3FF)),
                          children: [
                            const _Cell(''),
                            const _Cell('Total', bold: true),
                            _Cell('$total', bold: true),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text('Student signature: ______________________',
                      style: TextStyle(color: secondaryLabel)),
                  const SizedBox(height: 14),
                  const Text('Level coordinator: ______________________',
                      style: TextStyle(color: secondaryLabel)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One table cell. Small helper widget so the table code stays short.
class _Cell extends StatelessWidget {
  final String text;
  final bool bold;
  final bool header;
  const _Cell(this.text, {this.bold = false, this.header = false});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: (bold || header) ? FontWeight.w600 : FontWeight.normal,
            color: header ? secondaryLabel : (bold ? accent : label),
            fontSize: header ? 13 : 14,
          ),
        ),
      );
}
