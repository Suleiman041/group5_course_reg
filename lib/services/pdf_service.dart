import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/course.dart';
import '../models/student.dart';
import '../theme.dart';

/// Builds the printable A4 course registration form as a PDF.
/// Kept separate from the screens (one job per class, Lecture 1).
class PdfService {
  static Future<Uint8List> buildCourseForm(Student s, List<Course> courses) async {
    final doc = pw.Document();

    // Load the BUK logo from the app's assets. If it's missing, the PDF just skips it.
    pw.MemoryImage? logo;
    try {
      final data = await rootBundle.load(logoPath);
      logo = pw.MemoryImage(data.buffer.asUint8List());
    } catch (_) {
      logo = null;
    }

    final total = courses.fold<int>(0, (sum, c) => sum + c.units);
    final now = DateTime.now();
    final date = '${now.day}/${now.month}/${now.year}';
    final semester = s.semester == 1 ? 'First' : 'Second';

    pw.Widget detail(String name, String value) => pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 2),
          child: pw.Row(children: [
            pw.SizedBox(width: 90, child: pw.Text(name)),
            pw.Expanded(
              child: pw.Text(value, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
          ]),
        );

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            if (logo != null) pw.Center(child: pw.Image(logo, width: 70, height: 70)),
            pw.SizedBox(height: 8),
            pw.Text('BAYERO UNIVERSITY, KANO',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.Text('Student Course Registration Form',
                textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 13)),
            pw.Divider(height: 24),
            detail('Name', s.name),
            detail('Reg No', s.regNo),
            detail('Department', s.department),
            detail('Level', '${s.level}'),
            detail('Semester', semester),
            detail('Date', date),
            pw.SizedBox(height: 16),
            pw.TableHelper.fromTextArray(
              headers: ['S/N', 'Course Code', 'Course Title', 'Units'],
              data: [
                for (var i = 0; i < courses.length; i++)
                  ['${i + 1}', courses[i].code, courses[i].title, '${courses[i].units}'],
                ['', '', 'TOTAL', '$total'],
              ],
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
              cellAlignments: {0: pw.Alignment.center, 3: pw.Alignment.center},
              columnWidths: {
                0: const pw.FixedColumnWidth(30),
                1: const pw.FixedColumnWidth(85),
                2: const pw.FlexColumnWidth(),
                3: const pw.FixedColumnWidth(40),
              },
            ),
            pw.SizedBox(height: 50),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(children: [
                  pw.Text('______________________'),
                  pw.Text('Student Signature'),
                ]),
                pw.Column(children: [
                  pw.Text('______________________'),
                  pw.Text('Level Coordinator'),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
    return doc.save();
  }
}
