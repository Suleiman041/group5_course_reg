import 'course.dart';

/// GPA on the 5-point scale.
/// GPA = sum(units x grade point) / sum(units)
class GpaCalculator {
  // TODO(group): confirm the grade points with the current BUK grading system.
  static const Map<String, int> gradePoints = {
    'A': 5,
    'B': 4,
    'C': 3,
    'D': 2,
    'E': 1,
    'F': 0,
  };

  /// [grades] maps each course to the grade the student got, e.g. {MCS5205: 'A'}.
  /// Courses without a grade are skipped.
  static double calculate(Map<Course, String> grades) {
    int totalUnits = 0;
    int totalPoints = 0;
    grades.forEach((course, grade) {
      final point = gradePoints[grade];
      if (point == null) return; // unknown or empty grade: skip it
      totalUnits += course.units;
      totalPoints += course.units * point;
    });
    if (totalUnits == 0) return 0.0; // avoids dividing by zero
    return totalPoints / totalUnits;
  }
}
