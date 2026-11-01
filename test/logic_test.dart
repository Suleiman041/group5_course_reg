// Unit tests for the app's rules (Lecture 1: unit testing; Lecture 5: white-box testing).
// Run with:  flutter test
import 'package:flutter_test/flutter_test.dart';

import 'package:group5_course_reg/models/course.dart';
import 'package:group5_course_reg/models/gpa_calculator.dart';
import 'package:group5_course_reg/models/registration.dart';

Course c(String code, int units) =>
    Course(code: code, title: code, units: units, level: 500, semester: 1);

void main() {
  group('Registration', () {
    test('adding a course increases total units', () {
      final r = Registration();
      expect(r.add(c('A', 3)), isNull); // null means success
      expect(r.totalUnits, 3);
    });

    test('the same course cannot be added twice', () {
      final r = Registration();
      r.add(c('A', 3));
      expect(r.add(c('A', 3)), isNotNull); // an error message comes back
      expect(r.totalUnits, 3);
    });

    test('cannot go above the maximum units', () {
      final r = Registration();
      for (var i = 0; i < 8; i++) {
        r.add(c('C$i', 3)); // 8 x 3 = 24, exactly the max
      }
      expect(r.totalUnits, r.maxUnits);
      expect(r.add(c('EXTRA', 3)), isNotNull);
      expect(r.totalUnits, r.maxUnits);
    });

    test('cannot submit below the minimum units', () {
      final r = Registration();
      r.add(c('A', 3));
      expect(r.canSubmit, isFalse);
    });

    test('dropping a course removes its units', () {
      final r = Registration();
      final a = c('A', 3);
      r.add(a);
      r.drop(a);
      expect(r.totalUnits, 0);
    });
  });

  group('Limits from the course outline', () {
    test('normal semester keeps 15 to 24', () {
      final r = Registration.forCourses([c('A', 10), c('B', 10)]); // 20 units offered
      expect(r.minUnits, 15);
      expect(r.maxUnits, 24);
    });

    test('a 26-unit semester raises the maximum to 26', () {
      final r = Registration.forCourses([c('A', 13), c('B', 13)]);
      expect(r.maxUnits, 26);
    });

    test('a 4-unit SIWES semester lowers the minimum to 4', () {
      final r = Registration.forCourses([c('SIWES', 4)]);
      expect(r.minUnits, 4);
      r.add(c('SIWES', 4));
      expect(r.canSubmit, isTrue);
    });
  });

  group('GPA', () {
    test('weighted by units', () {
      // A (5) on 3 units + C (3) on 2 units = (15 + 6) / 5 = 4.2
      final gpa = GpaCalculator.calculate({c('X', 3): 'A', c('Y', 2): 'C'});
      expect(gpa, closeTo(4.2, 0.001));
    });

    test('no grades gives 0 instead of crashing', () {
      expect(GpaCalculator.calculate({}), 0.0);
    });
  });
}
