import '../models/course.dart';

/// The list of courses the app offers, taken from the official
/// Mechatronics Engineering course outline (Levels 1 to 5).
const List<Course> courseCatalog = [
  // 100 Level, first semester (17 units)
  Course(code: 'BUK-MCE101', title: 'Elementary Mathematics III (Vectors, Geometry and Dynamics)', units: 2, level: 100, semester: 1),
  Course(code: 'BUK-MCE103', title: 'General Physics II (Electricity. and Magnetism)', units: 2, level: 100, semester: 1),
  Course(code: 'CHM101', title: 'General Chemistry I', units: 2, level: 100, semester: 1),
  Course(code: 'CHM107', title: 'General Chemistry Practical I', units: 1, level: 100, semester: 1),
  Course(code: 'GET101', title: 'Engineer in Society', units: 1, level: 100, semester: 1),
  Course(code: 'GST111', title: 'Communication In English', units: 2, level: 100, semester: 1),
  Course(code: 'MCE101', title: 'Introduction to Mechatronics Engineering', units: 2, level: 100, semester: 1),
  Course(code: 'MTH101', title: 'Elementary Mathematics I', units: 2, level: 100, semester: 1),
  Course(code: 'PHY101', title: 'General Physics I', units: 2, level: 100, semester: 1),
  Course(code: 'PHY107', title: 'General Physics Practical I', units: 1, level: 100, semester: 1),
  // 100 Level, second semester (14 units)
  Course(code: 'BUK-MCE104', title: 'Introduction to Python Programming', units: 2, level: 100, semester: 2),
  Course(code: 'CHM102', title: 'General Chemistry II', units: 2, level: 100, semester: 2),
  Course(code: 'CHM108', title: 'General Chemistry Practical II', units: 1, level: 100, semester: 2),
  Course(code: 'GET102', title: 'Engineering Graphics and Solid Modelling', units: 2, level: 100, semester: 2),
  Course(code: 'GST112', title: 'Nigerian People And Culture', units: 2, level: 100, semester: 2),
  Course(code: 'MTH102', title: 'Elementary Mathematics II', units: 2, level: 100, semester: 2),
  Course(code: 'PHY103', title: 'General Physics III', units: 2, level: 100, semester: 2),
  Course(code: 'PHY108', title: 'General Physics Practical II', units: 1, level: 100, semester: 2),
  // 200 Level, first semester (21 units)
  Course(code: 'BUK-MCE201', title: 'Introduction to Matlab Programming', units: 2, level: 200, semester: 1),
  Course(code: 'ENT211', title: 'Entrepreneurship and Innovation', units: 2, level: 200, semester: 1),
  Course(code: 'GET201', title: 'Applied Electricity I', units: 3, level: 200, semester: 1),
  Course(code: 'GET202', title: 'Engineering Materials', units: 3, level: 200, semester: 1),
  Course(code: 'GET204', title: 'Students Workshop Practice', units: 2, level: 200, semester: 1),
  Course(code: 'GET206', title: 'Fundamentals of Thermodynamics', units: 3, level: 200, semester: 1),
  Course(code: 'GET207', title: 'Applied Mechanics', units: 3, level: 200, semester: 1),
  Course(code: 'GET209', title: 'Engineering Mathematics I', units: 3, level: 200, semester: 1),
  // 200 Level, second semester (22 units)
  Course(code: 'BUK-MCE202', title: 'Dynamics', units: 2, level: 200, semester: 2),
  Course(code: 'GET203', title: 'Engineering Graphics and Soil Modeling II', units: 3, level: 200, semester: 2),
  Course(code: 'GET205', title: 'Fundamentals of Fluid Mechanics', units: 3, level: 200, semester: 2),
  Course(code: 'GET208', title: 'Strength of Materials', units: 3, level: 200, semester: 2),
  Course(code: 'GET210', title: 'Engineering Mathematics II', units: 3, level: 200, semester: 2),
  Course(code: 'GET211', title: 'Computing and Software Engineering', units: 3, level: 200, semester: 2),
  Course(code: 'GET299', title: 'SIWES I', units: 3, level: 200, semester: 2),
  Course(code: 'GST212', title: 'Philosophy, Logic and Human Existence', units: 2, level: 200, semester: 2),
  // 300 Level, first semester (20 units)
  Course(code: 'GET207', title: 'Applied Mechanics', units: 3, level: 300, semester: 1),
  Course(code: 'BUK-MCE301', title: 'Control Engineering Fundamentals', units: 3, level: 300, semester: 1),
  Course(code: 'BUK-MCE308', title: 'Engineering Economics', units: 3, level: 300, semester: 1),
  Course(code: 'GET301', title: 'Engineering Mathematics III', units: 3, level: 300, semester: 1),
  Course(code: 'GET305', title: 'Engineering Statistics and Data Analytics', units: 3, level: 300, semester: 1),
  Course(code: 'GET307', title: 'Introduction to Artificial Intelligence, Machine Learning and Convergent Technologies', units: 3, level: 300, semester: 1),
  Course(code: 'GST312', title: 'Peace and Conflict Resolution', units: 2, level: 300, semester: 1),
  // 300 Level, second semester (23 units)
  Course(code: 'BUK-MCE202', title: 'Dynamics', units: 2, level: 300, semester: 2),
  Course(code: 'BUK-MCE302', title: 'Digital Electronics', units: 2, level: 300, semester: 2),
  Course(code: 'BUK-MCE303', title: 'Electrical Circuits Analysis', units: 2, level: 300, semester: 2),
  Course(code: 'ENT312', title: 'Venture Creation', units: 2, level: 300, semester: 2),
  Course(code: 'GET302', title: 'Engineering Mathematics IV', units: 3, level: 300, semester: 2),
  Course(code: 'GET304', title: 'Engineering Communication, Technical Writing and Presentation', units: 3, level: 300, semester: 2),
  Course(code: 'GET306', title: 'Renewable Energy Systems and Technology', units: 3, level: 300, semester: 2),
  Course(code: 'GET399', title: 'SIWES II: Students Work Experience Scheme', units: 4, level: 300, semester: 2),
  Course(code: 'MCE321', title: 'Design of Mechatronic Engineering and Robotics Systems I', units: 2, level: 300, semester: 2),
  // 400 Level, first semester (26 units)
  Course(code: 'EEP4201', title: 'Venture Creation and Growth', units: 2, level: 400, semester: 1),
  Course(code: 'EGR4101', title: 'ENGINEER IN SOCIETY 3', units: 1, level: 400, semester: 1),
  Course(code: 'EGR4201', title: 'ENGINEERING STATISTICS', units: 2, level: 400, semester: 1),
  Course(code: 'MCS4203', title: 'Sensors And Actuators', units: 2, level: 400, semester: 1),
  Course(code: 'MCS4204', title: 'Measurement And Instrumentation', units: 2, level: 400, semester: 1),
  Course(code: 'MCS4206', title: 'Control Engineering II', units: 2, level: 400, semester: 1),
  Course(code: 'MCS4207', title: 'Introduction to Robotics', units: 2, level: 400, semester: 1),
  Course(code: 'MCS4208', title: 'Computer hardware Engineering', units: 2, level: 400, semester: 1),
  Course(code: 'MCS4209', title: 'Group Project', units: 2, level: 400, semester: 1),
  Course(code: 'MCS4303', title: 'Electronics II', units: 3, level: 400, semester: 1),
  Course(code: 'MCS4304', title: 'Mechanics of Machines', units: 3, level: 400, semester: 1),
  Course(code: 'MCS4305', title: 'Laboratory III', units: 3, level: 400, semester: 1),
  // 400 Level, second semester (4 units)
  Course(code: 'EGR4401', title: 'SIWES II', units: 4, level: 400, semester: 2),
  // 500 Level, first semester (23 units)
  Course(code: 'MCS5202', title: 'Control Engineering III', units: 2, level: 500, semester: 1),
  Course(code: 'MCS5203', title: 'Process automation', units: 2, level: 500, semester: 1),
  Course(code: 'MCS5303', title: 'Digital signal processing', units: 3, level: 500, semester: 1),
  Course(code: 'MCS5305', title: 'Microcomputers and microprocessor systems', units: 3, level: 500, semester: 1),
  Course(code: 'MCS5307', title: 'Automation Laboratory', units: 3, level: 500, semester: 1),
  Course(code: 'MCS5601', title: 'Final year project', units: 6, level: 500, semester: 1),
  Course(code: 'MEC5405', title: 'ENGINEERING MANAGEMENT', units: 4, level: 500, semester: 1),
  // 500 Level, second semester (20 units)
  Course(code: 'MCS5205', title: 'Computer software engineering II', units: 2, level: 500, semester: 2),
  Course(code: 'MCS5211', title: 'Microcontrollers and embedded systems', units: 2, level: 500, semester: 2),
  Course(code: 'MCS5212', title: 'Computer aided manufacturing', units: 2, level: 500, semester: 2),
  Course(code: 'MCS5213', title: 'Renewable Energy Resources', units: 2, level: 500, semester: 2),
  Course(code: 'MCS5301', title: 'Power Electronics and drive', units: 3, level: 500, semester: 2),
  Course(code: 'MCS5302', title: 'Automation and Robotics', units: 3, level: 500, semester: 2),
  Course(code: 'MCS5304', title: 'MEMS and VLSI', units: 3, level: 500, semester: 2),
  Course(code: 'MCS5306', title: 'Systems modeling and simulation', units: 3, level: 500, semester: 2),
];

/// Returns only the courses for one level and semester.
List<Course> coursesFor(int level, int semester) => courseCatalog
    .where((c) => c.level == level && c.semester == semester)
    .toList();

/// Finds a course by its code (used when loading saved registrations).
/// A few courses appear at two levels; they have the same units, so the first match is fine.
Course? courseByCode(String code) {
  for (final c in courseCatalog) {
    if (c.code == code) return c;
  }
  return null;
}
