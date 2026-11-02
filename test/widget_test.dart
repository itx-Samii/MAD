import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled1/main.dart';

Future<void> _submitLogin(WidgetTester tester) async {
  final button = find.widgetWithText(FilledButton, 'Open my portfolio');
  await tester.ensureVisible(button);
  await tester.tap(button);
  await tester.pumpAndSettle();
}

Future<void> _openPortfolio(WidgetTester tester, {double width = 390}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 844);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(const MyApp());
  await tester.enterText(find.byType(TextFormField).first, '66157');
  await tester.enterText(find.byType(TextFormField).last, 'demo');
  await _submitLogin(tester);
}

double _detailsOpacity(WidgetTester tester) => tester
    .widget<FadeTransition>(
      find.descendant(
        of: find.byKey(const ValueKey('personal-information-details')),
        matching: find.byType(FadeTransition),
      ),
    )
    .opacity
    .value;

double _routeOpacity(WidgetTester tester, Type pageType) => tester
    .widget<FadeTransition>(
      find
          .ancestor(
            of: find.byType(pageType),
            matching: find.byType(FadeTransition),
          )
          .first,
    )
    .opacity
    .value;

void main() {
  testWidgets('Invalid credentials keep the user on the login screen', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await _submitLogin(tester);
    expect(find.text('Enter your student email or SAP ID.'), findsOneWidget);
    expect(
      find.text('Password must be at least 4 characters.'),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
    await tester.enterText(find.byType(TextFormField).last, '123');
    await _submitLogin(tester);

    expect(
      find.text('Enter a valid student email or numeric SAP ID.'),
      findsOneWidget,
    );
    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(PortfolioPage), findsNothing);
  });

  testWidgets(
    'SAP ID login opens the portfolio and sign-out returns to login',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.enterText(find.byType(TextFormField).first, '66157');
      await tester.enterText(find.byType(TextFormField).last, 'demo');
      final button = find.widgetWithText(FilledButton, 'Open my portfolio');
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 180));
      expect(_routeOpacity(tester, PortfolioPage), inExclusiveRange(0, 1));
      await tester.pumpAndSettle();

      expect(find.byType(PortfolioPage), findsOneWidget);
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('profile-header')),
          matching: find.text('66157@students.riphah.edu.pk'),
        ),
        findsOneWidget,
      );
      expect(find.text('Fee Management System'), findsOneWidget);
      expect(find.text('Attendance Management System'), findsOneWidget);
      expect(find.text('Inventory Management System'), findsOneWidget);

      await tester.tap(find.byTooltip('Sign out'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      await tester.tap(find.widgetWithText(TextButton, 'Sign out'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 180));
      expect(_routeOpacity(tester, LoginPage), inExclusiveRange(0, 1));
      await tester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.byType(PortfolioPage), findsNothing);
    },
  );

  testWidgets('Profile header smoothly expands and collapses on a phone', (
    tester,
  ) async {
    await _openPortfolio(tester);
    final header = find.byKey(const ValueKey('profile-header'));
    final avatar = find.byKey(const ValueKey('profile-avatar'));
    final collapsedHeight = tester.getSize(header).height;
    expect(tester.getSize(avatar).width, 110);

    await tester.tap(header);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 180));
    expect(tester.getSize(avatar).width, inExclusiveRange(110, 150));
    await tester.pumpAndSettle();
    expect(tester.getSize(avatar).width, 150);
    expect(tester.getSize(header).height, greaterThan(collapsedHeight));
    expect(find.text('Tap to collapse'), findsOneWidget);

    await tester.tap(header);
    await tester.pumpAndSettle();
    expect(tester.getSize(avatar).width, 110);
    expect(tester.getSize(header).height, collapsedHeight);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Read More expands About me and Show Less restores its height', (
    tester,
  ) async {
    await _openPortfolio(tester);
    final about = find.byKey(const ValueKey('about-me-cross-fade'));
    final collapsedHeight = tester.getSize(about).height;
    await tester.ensureVisible(find.text('Read More'));
    await tester.tap(find.text('Read More'));
    await tester.pumpAndSettle();
    expect(find.text('Show Less'), findsOneWidget);
    expect(tester.getSize(about).height, greaterThan(collapsedHeight));

    await tester.ensureVisible(find.text('Show Less'));
    await tester.tap(find.text('Show Less'));
    await tester.pumpAndSettle();
    expect(tester.getSize(about).height, collapsedHeight);
    expect(find.text('Read More'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Personal information fades to 25 percent and restores', (
    tester,
  ) async {
    await _openPortfolio(tester);
    expect(_detailsOpacity(tester), 1);
    final dim = find.widgetWithText(TextButton, 'Dim');
    await tester.ensureVisible(dim);
    await tester.tap(dim);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 180));
    expect(_detailsOpacity(tester), inExclusiveRange(0.25, 1));
    await tester.pumpAndSettle();
    expect(_detailsOpacity(tester), 0.25);

    await tester.tap(find.widgetWithText(TextButton, 'Show'));
    await tester.pumpAndSettle();
    expect(_detailsOpacity(tester), 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Reduced motion works immediately on a narrow phone', (
    tester,
  ) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await _openPortfolio(tester, width: 320);
    await tester.tap(find.byKey(const ValueKey('profile-header')));
    await tester.pump();
    expect(
      tester.getSize(find.byKey(const ValueKey('profile-avatar'))).width,
      150,
    );

    await tester.ensureVisible(find.text('Read More'));
    await tester.tap(find.text('Read More'));
    await tester.pumpAndSettle();
    expect(find.text('Show Less'), findsOneWidget);

    final dim = find.widgetWithText(TextButton, 'Dim');
    await tester.ensureVisible(dim);
    await tester.tap(dim);
    await tester.pump();
    expect(_detailsOpacity(tester), 0.25);
    expect(tester.takeException(), isNull);
  });
}
