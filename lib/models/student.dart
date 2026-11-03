class Student {
  final String name;
  final String sapId;
  final String email;
  final String photo;
  final String about;
  final String role;
  final String university;
  final String program;
  final String semester;
  final String phone;

  const Student({
    required this.name,
    required this.sapId,
    required this.email,
    required this.photo,
    required this.about,
    this.role = 'Student',
    this.university = 'Riphah International University, I-14',
    this.program = 'BS Software Engineering',
    this.semester = '5th',
    this.phone = '0349 5999656',
  });
}
