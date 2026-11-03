import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled1/main.dart';

const _emailKey = ValueKey('login-email');
const _passwordKey = ValueKey('login-password');
const _submitKey = ValueKey('login-submit');
const _genericError = "We couldn't sign you in. Check your email and password.";

EditableText _passwordInput(WidgetTester tester) => tester.widget<EditableText>(
  find.descendant(
    of: find.byKey(_passwordKey),
    matching: find.byType(EditableText),
  ),
);

Future<void> _enterCredentials(
  WidgetTester tester, {
  String email = '66157@students.riphah.edu.pk',
  String password = '1234',
}) async {
  await tester.enterText(find.byKey(_emailKey), email);
  await tester.enterText(find.byKey(_passwordKey), password);
}

Future<void> _submit(WidgetTester tester) async {
  await tester.ensureVisible(find.byKey(_submitKey));
  await tester.tap(find.byKey(_submitKey));
  await tester.pumpAndSettle();
}

Future<void> _openPortal(
  WidgetTester tester, {
  double width = 390,
  double height = 844,
  String email = '66157@students.riphah.edu.pk',
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(const MyApp());
  await _enterCredentials(tester, email: email);
  await _submit(tester);
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

String _photoAsset(WidgetTester tester) =>
    (tester.widget<Image>(find.byKey(const ValueKey('profile-photo'))).image
            as AssetImage)
        .assetName;

Finder _personalDetail(String value) => find.descendant(
  of: find.byKey(const ValueKey('personal-information-details')),
  matching: find.text(value),
);

void main() {
  testWidgets('Empty and malformed input shows inline guidance', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await _submit(tester);
    expect(find.text('Enter your student email or SAP ID.'), findsOneWidget);
    expect(find.text('Enter your password.'), findsOneWidget);

    await _enterCredentials(tester, email: 'invalid-email');
    await _submit(tester);
    expect(
      find.text('Enter a valid student email or numeric SAP ID.'),
      findsOneWidget,
    );
    expect(find.byType(StudentProfilePage), findsNothing);
    expect(find.byKey(const ValueKey('login-spinner')), findsNothing);
  });

  testWidgets('Unknown account and wrong password share a generic error', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await _enterCredentials(
      tester,
      email: 'unknown@students.riphah.edu.pk',
      password: 'wrong',
    );
    await _submit(tester);
    expect(find.text(_genericError), findsOneWidget);
    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(StudentProfilePage), findsNothing);

    await _enterCredentials(tester, password: 'wrong');
    expect(find.text(_genericError), findsNothing);
    await _submit(tester);
    expect(find.text(_genericError), findsOneWidget);
    expect(find.byType(StudentProfilePage), findsNothing);
    final error = tester.widget<Text>(
      find.descendant(
        of: find.byKey(const ValueKey('login-error')),
        matching: find.byType(Text),
      ),
    );
    expect(error.data, isNot(contains('1234')));
    expect(error.data, isNot(contains('66157')));
  });

  testWidgets('66157 signs in as Zain with img.png and complete profile', (
    tester,
  ) async {
    await _openPortal(tester);
    expect(find.byType(StudentProfilePage), findsOneWidget);
    expect(find.text('Muhammad Zain Khan'), findsOneWidget);
    expect(_photoAsset(tester), 'image/img.png');
    expect(_personalDetail('Student'), findsOneWidget);
    expect(_personalDetail('66157'), findsOneWidget);
    expect(_personalDetail('66157@students.riphah.edu.pk'), findsOneWidget);
    expect(
      _personalDetail('Riphah International University, I-14'),
      findsOneWidget,
    );
    expect(_personalDetail('BS Software Engineering'), findsOneWidget);
    expect(_personalDetail('Not specified'), findsOneWidget);
    expect(find.text('Sameer Abdullah'), findsNothing);
    expect(find.text('About me'), findsOneWidget);
    expect(find.text('My Portfolio'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('64860 has Sameer own photo and details', (tester) async {
    await _openPortal(tester, email: '64860@students.riphah.edu.pk');
    expect(find.text('Sameer Abdullah'), findsOneWidget);
    expect(_personalDetail('64860@students.riphah.edu.pk'), findsOneWidget);
    expect(find.text('64860'), findsOneWidget);
    expect(_photoAsset(tester), 'image/profile.jpg');
    expect(find.text('Muhammad Zain Khan'), findsNothing);
    expect(find.text('66157@students.riphah.edu.pk'), findsNothing);
  });

  testWidgets('Numeric SAP ID opens the matching existing account', (
    tester,
  ) async {
    await _openPortal(tester, email: '64860');
    expect(find.text('Sameer Abdullah'), findsOneWidget);
    expect(_personalDetail('64860@students.riphah.edu.pk'), findsOneWidget);
    expect(_photoAsset(tester), 'image/profile.jpg');
  });

  testWidgets('Password toggle, Next and Done work with guarded loading', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await _enterCredentials(tester);
    expect(_passwordInput(tester).obscureText, isTrue);
    await tester.ensureVisible(find.byTooltip('Show password'));
    await tester.tap(find.byTooltip('Show password'));
    await tester.pump();
    expect(_passwordInput(tester).obscureText, isFalse);
    await tester.tap(find.byTooltip('Hide password'));
    await tester.pump();

    await tester.showKeyboard(find.byKey(_emailKey));
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pump();
    final passwordInput = tester.widget<EditableText>(
      find.descendant(
        of: find.byKey(_passwordKey),
        matching: find.byType(EditableText),
      ),
    );
    expect(passwordInput.focusNode.hasFocus, isTrue);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(find.byKey(const ValueKey('login-spinner')), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byKey(_submitKey)).onPressed,
      isNull,
    );
    expect(
      tester.widget<TextFormField>(find.byKey(_emailKey)).enabled,
      isFalse,
    );
    await tester.pumpAndSettle();
    expect(find.byType(StudentProfilePage), findsOneWidget);
    expect(find.byKey(const ValueKey('login-spinner')), findsNothing);
  });

  testWidgets(
    'Login and logout fade, cancellation and account switching work',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await _enterCredentials(tester, email: ' 66157@STUDENTS.RIPHAH.EDU.PK ');
      await tester.ensureVisible(find.byKey(_submitKey));
      await tester.tap(find.byKey(_submitKey));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 450));
      await tester.pump(const Duration(milliseconds: 180));
      expect(_routeOpacity(tester, StudentProfilePage), inExclusiveRange(0, 1));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Logout'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Muhammad Zain Khan'), findsOneWidget);

      await tester.tap(find.byTooltip('Logout'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Logout'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 180));
      expect(_routeOpacity(tester, LoginPage), inExclusiveRange(0, 1));
      await tester.pumpAndSettle();
      expect(find.byType(StudentProfilePage), findsNothing);
      expect(
        tester.widget<TextFormField>(find.byKey(_passwordKey)).controller!.text,
        isEmpty,
      );

      await _enterCredentials(tester, email: '64860@students.riphah.edu.pk');
      await _submit(tester);
      expect(find.text('Sameer Abdullah'), findsOneWidget);
      expect(find.text('Muhammad Zain Khan'), findsNothing);
      expect(_photoAsset(tester), 'image/profile.jpg');
    },
  );

  testWidgets('Photo animates between 110 and 150 pixels and restores', (
    tester,
  ) async {
    await _openPortal(tester);
    final avatar = find.byKey(const ValueKey('profile-avatar'));
    final photoButton = find.byKey(const ValueKey('profile-photo-button'));
    expect(tester.getSize(avatar).width, 110);
    await tester.tap(photoButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 180));
    expect(tester.getSize(avatar).width, inExclusiveRange(110, 150));
    await tester.pumpAndSettle();
    expect(tester.getSize(avatar).width, 150);
    await tester.tap(photoButton);
    await tester.pumpAndSettle();
    expect(tester.getSize(avatar).width, 110);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Personal information hides and shows with opacity animation', (
    tester,
  ) async {
    await _openPortal(tester);
    expect(_detailsOpacity(tester), 1);
    final hide = find.widgetWithText(TextButton, 'Hide');
    await tester.ensureVisible(hide);
    await tester.tap(hide);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 180));
    expect(_detailsOpacity(tester), inExclusiveRange(0, 1));
    await tester.pumpAndSettle();
    expect(_detailsOpacity(tester), 0);
    await tester.tap(find.widgetWithText(TextButton, 'Show'));
    await tester.pumpAndSettle();
    expect(_detailsOpacity(tester), 1);
  });

  testWidgets('About section expands and returns to its compact height', (
    tester,
  ) async {
    await _openPortal(tester);
    final about = find.byKey(const ValueKey('about-me-cross-fade'));
    final initialHeight = tester.getSize(about).height;
    await tester.ensureVisible(find.text('Read more'));
    await tester.tap(find.text('Read more'));
    await tester.pumpAndSettle();
    expect(tester.getSize(about).height, greaterThan(initialHeight));
    await tester.ensureVisible(find.text('Show less'));
    await tester.tap(find.text('Show less'));
    await tester.pumpAndSettle();
    expect(tester.getSize(about).height, initialHeight);
  });

  testWidgets('Skills and management projects appear inline in the portfolio', (
    tester,
  ) async {
    await _openPortal(tester);
    expect(find.text('Skills'), findsOneWidget);
    expect(find.text('My projects'), findsOneWidget);
    expect(find.text('Fee Management System'), findsOneWidget);
    expect(find.text('Attendance Management System'), findsOneWidget);
    expect(find.text('Inventory Management System'), findsOneWidget);
    expect(find.text('Flutter & Dart'), findsOneWidget);
    await tester.ensureVisible(find.text('Inventory Management System'));
    await tester.pumpAndSettle();
    expect(
      find.text('Inventory Management System').hitTestable(),
      findsOneWidget,
    );
    expect(find.byType(StudentProfilePage), findsOneWidget);
    expect(find.text('Muhammad Zain Khan'), findsOneWidget);
  });

  testWidgets('Reduced motion and a narrow screen keep all controls usable', (
    tester,
  ) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await _openPortal(tester, width: 320, height: 640);
    await tester.tap(find.byKey(const ValueKey('profile-photo-button')));
    await tester.pump();
    expect(
      tester.getSize(find.byKey(const ValueKey('profile-avatar'))).width,
      150,
    );
    await tester.ensureVisible(find.text('Read more'));
    await tester.tap(find.text('Read more'));
    await tester.pumpAndSettle();
    expect(find.text('Show less'), findsOneWidget);
    final hide = find.widgetWithText(TextButton, 'Hide');
    await tester.ensureVisible(hide);
    await tester.tap(hide);
    await tester.pump();
    expect(_detailsOpacity(tester), 0);
    expect(tester.takeException(), isNull);
  });
}
