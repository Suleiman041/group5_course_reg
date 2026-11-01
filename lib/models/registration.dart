import 'dart:math';

import 'course.dart';

/// The business rules of registration. It has NO screens and NO storage
/// code, only logic, so it can be unit tested on its own (Lecture 1:
/// unit testing; high cohesion, low coupling).
class Registration {
  // Usual limits per semester.
  // TODO(group): confirm the real minimum and maximum units with the department.
  static const int defaultMin = 15;
  static const int defaultMax = 24;

  final int minUnits;
  final int maxUnits;

  Registration({this.minUnits = defaultMin, this.maxUnits = defaultMax});

  /// Builds a registration whose limits fit the courses offered that semester.
  /// Normally 15 to 24, but stretched when the outline's own total falls
  /// outside that range (e.g. 26 units at 400 Level first semester, or
  /// only 4 units of SIWES at 400 Level second semester).
  factory Registration.forCourses(List<Course> offered) {
    final total = offered.fold<int>(0, (sum, c) => sum + c.units);
    return Registration(
      minUnits: min(defaultMin, total),
      maxUnits: max(defaultMax, total),
    );
  }

  // The underscore makes the list PRIVATE (Lecture 1: encapsulation).
  // Other code can only change it through add() and drop(), which check the rules.
  final List<Course> _courses = [];

  List<Course> get courses => List.unmodifiable(_courses);

  int get totalUnits => _courses.fold<int>(0, (sum, c) => sum + c.units);

  bool contains(Course course) => _courses.any((c) => c.code == course.code);

  /// Tries to add a course. Returns null if it worked,
  /// or an error message explaining why it was refused.
  String? add(Course course) {
    if (contains(course)) {
      return '${course.code} is already registered.';
    }
    if (totalUnits + course.units > maxUnits) {
      return 'Adding ${course.code} would exceed the maximum of $maxUnits units.';
    }
    _courses.add(course);
    return null;
  }

  void drop(Course course) {
    _courses.removeWhere((c) => c.code == course.code);
  }

  /// Registration can only be submitted when units are within the limits.
  bool get canSubmit => totalUnits >= minUnits && totalUnits <= maxUnits;

  String get statusMessage {
    if (totalUnits < minUnits) {
      return 'Add ${minUnits - totalUnits} more unit(s) to reach the minimum of $minUnits.';
    }
    return 'Units are within the allowed range.';
  }
}
