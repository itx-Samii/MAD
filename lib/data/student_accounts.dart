import '../models/student.dart';

/// Local demonstration accounts, not a production authentication service.
class DemoStudentAccounts {
  static const zain = Student(
    name: 'Muhammad Zain Khan',
    sapId: '66157',
    email: '66157@students.riphah.edu.pk',
    photo: 'image/img.png',
    about:
        "Hi! I'm Muhammad Zain Khan, a Software Engineering student at "
        'Riphah International University, I-14. I enjoy building mobile apps '
        'with Flutter and like learning something new every day.',
  );

  static const sameer = Student(
    name: 'Sameer Abdullah',
    sapId: '64860',
    email: '64860@students.riphah.edu.pk',
    photo: 'image/profile.jpg',
    about:
        "Hi! I'm Sameer, a Software Engineering student at Riphah "
        'International University, I-14. I enjoy building mobile apps with '
        'Flutter and like learning something new every day.',
  );

  static const _accounts = [
    (student: zain, password: '1234'),
    (student: sameer, password: '1234'),
  ];

  static Future<Student?> signIn(String email, String password) async {
    // A brief local delay lets the UI communicate that sign-in is in progress.
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final normalizedEmail = email.trim().toLowerCase();
    for (final account in _accounts) {
      if (account.student.email == normalizedEmail &&
          account.password == password) {
        return account.student;
      }
    }
    return null;
  }
}
