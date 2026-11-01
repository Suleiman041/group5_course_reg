/// A single course that can be registered, e.g. MCS5205.
///
/// This is a CLASS (Lecture 1): it bundles the course's data
/// (attributes) in one object. Every course in the catalogue is an
/// INSTANCE of this class.
class Course {
  final String code;   // e.g. "MCS5205"
  final String title;  // e.g. "Computer Software Engineering II"
  final int units;     // credit units, e.g. 3
  final int level;     // 100, 200, 300, 400 or 500
  final int semester;  // 1 = first semester, 2 = second semester

  const Course({
    required this.code,
    required this.title,
    required this.units,
    required this.level,
    required this.semester,
  });
}
