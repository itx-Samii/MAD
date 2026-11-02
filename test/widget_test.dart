import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled1/main.dart';

Future<void> _submitLogin(WidgetTester tester) async {
  final button = find.widgetWithText(FilledButton, 'Open my portfolio');
  await tester.ensureVisible(button);
  await tester.tap(button);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Invalid credentials keep the user on the login screen',
      (tester) async {
    await tester.pumpWidget(const MyApp());

    await _submitLogin(tester);
    expect(find.text('Enter your student email or SAP ID.'), findsOneWidget);
    expect(find.text('Password must be at least 4 characters.'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
    await tester.enterText(find.byType(TextFormField).last, '123');
    await _submitLogin(tester);

    expect(find.text('Enter a valid student email or numeric SAP ID.'),
        findsOneWidget);
    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(PortfolioPage), findsNothing);
  });

  testWidgets('SAP ID login opens the portfolio and sign-out returns to login',
      (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.enterText(find.byType(TextFormField).first, '66157');
    await tester.enterText(find.byType(TextFormField).last, 'demo');
    await _submitLogin(tester);

    expect(find.byType(PortfolioPage), findsOneWidget);
    expect(find.text('66157@students.riphah.edu.pk'), findsOneWidget);
    expect(find.text('Fee Management System'), findsOneWidget);
    expect(find.text('Attendance Management System'), findsOneWidget);
    expect(find.text('Inventory Management System'), findsOneWidget);

    await tester.tap(find.byTooltip('Sign out'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Sign out'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(PortfolioPage), findsNothing);
  });
}