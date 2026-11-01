// Widget test: checks that the app starts and shows the login screen.
// Run with:  flutter test
import 'package:flutter_test/flutter_test.dart';

import 'package:group5_course_reg/main.dart';

void main() {
  testWidgets('App opens on the login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const CourseRegApp());

    expect(find.text('Bayero University, Kano'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
    expect(find.text('New student? Create an account'), findsOneWidget);
  });
}
