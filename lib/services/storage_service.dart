import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/student.dart';

/// Everything the app saves on the phone goes through this one class.
/// Screens never touch storage directly, so if we later switch to a
/// real database only this file changes (low coupling, Lecture 1).
///
/// Saved keys:
///   'students'                           -> all accounts, as JSON
///   'reg_<regNo>_<level>_<semester>'     -> registered course codes for that semester
///   'grades_<regNo>_<level>_<semester>'  -> course code -> grade for that semester
/// Saving per level and semester keeps each semester's registration
/// separate, so changing level in the profile doesn't mix them up.
class StorageService {
  static String hashPassword(String password) =>
      sha256.convert(utf8.encode(password)).toString();

  static String _semesterKey(String prefix, Student s) =>
      '${prefix}_${s.regNo}_${s.level}_${s.semester}';

  static Future<Map<String, dynamic>> _loadStudents() async {
    final prefs = await SharedPreferences.getInstance();
    final text = prefs.getString('students');
    if (text == null) return {};
    return jsonDecode(text) as Map<String, dynamic>;
  }

  static Future<void> _saveStudents(Map<String, dynamic> students) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('students', jsonEncode(students));
  }

  /// Creates an account. Returns null on success, or an error message.
  static Future<String?> signUp(Student student) async {
    final students = await _loadStudents();
    if (students.containsKey(student.regNo)) {
      return 'An account with this reg number already exists.';
    }
    students[student.regNo] = student.toJson();
    await _saveStudents(students);
    return null;
  }

  /// Saves changes made on the Profile screen.
  static Future<void> updateStudent(Student student) async {
    final students = await _loadStudents();
    students[student.regNo] = student.toJson();
    await _saveStudents(students);
  }

  /// Returns the student if reg number and password match, otherwise null.
  static Future<Student?> login(String regNo, String password) async {
    final students = await _loadStudents();
    final data = students[regNo];
    if (data == null) return null;
    final student = Student.fromJson(data as Map<String, dynamic>);
    if (student.passwordHash != hashPassword(password)) return null;
    return student;
  }

  static Future<void> saveRegistration(Student s, List<String> codes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_semesterKey('reg', s), codes);
  }

  static Future<List<String>> loadRegistration(Student s) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_semesterKey('reg', s)) ?? [];
  }

  static Future<void> saveGrades(Student s, Map<String, String> grades) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_semesterKey('grades', s), jsonEncode(grades));
  }

  static Future<Map<String, String>> loadGrades(Student s) async {
    final prefs = await SharedPreferences.getInstance();
    final text = prefs.getString(_semesterKey('grades', s));
    if (text == null) return {};
    return Map<String, String>.from(jsonDecode(text) as Map);
  }
}
