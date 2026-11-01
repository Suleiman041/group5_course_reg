/// A registered user of the app.
///
/// toJson / fromJson turn the object into text and back, so it can be
/// saved on the phone. This is the same idea as "serialization"
/// (pickling) from Lecture 1.
class Student {
  final String regNo;
  final String name;
  final String department;
  final int level;
  final int semester;
  final String passwordHash; // the password is stored HASHED, never as plain text

  Student({
    required this.regNo,
    required this.name,
    required this.department,
    required this.level,
    required this.semester,
    required this.passwordHash,
  });

  /// Makes a copy with some details changed (used when editing the profile).
  /// The reg number never changes, because it identifies the student.
  Student copyWith({
    String? name,
    String? department,
    int? level,
    int? semester,
    String? passwordHash,
  }) =>
      Student(
        regNo: regNo,
        name: name ?? this.name,
        department: department ?? this.department,
        level: level ?? this.level,
        semester: semester ?? this.semester,
        passwordHash: passwordHash ?? this.passwordHash,
      );

  Map<String, dynamic> toJson() => {
        'regNo': regNo,
        'name': name,
        'department': department,
        'level': level,
        'semester': semester,
        'passwordHash': passwordHash,
      };

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        regNo: json['regNo'] as String,
        name: json['name'] as String,
        department: json['department'] as String,
        level: json['level'] as int,
        semester: json['semester'] as int,
        passwordHash: json['passwordHash'] as String,
      );
}
