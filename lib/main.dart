import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'theme.dart';

/// Entry point: Flutter starts here.
void main() {
  runApp(const CourseRegApp());
}

/// The root widget. In Flutter EVERYTHING on screen is a widget (Lecture 3).
class CourseRegApp extends StatelessWidget {
  const CourseRegApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BUK Course Registration',
      debugShowCheckedModeBanner: false,
      // Material design = the Android look (Lecture 3: Material vs Cupertino).
      // Colours come from theme.dart.
      theme: buildTheme(),
      home: const LoginScreen(),
    );
  }
}
