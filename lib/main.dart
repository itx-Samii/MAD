import 'package:flutter/material.dart';

import 'screens/login_page.dart';
import 'theme/app_theme.dart';
import 'widgets/mobile_preview.dart';

export 'screens/login_page.dart';
export 'screens/student_profile_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Riphah Student Portfolio',
    debugShowCheckedModeBanner: false,
    theme: PortalTheme.data,
    builder: (context, child) =>
        MobilePreview(child: child ?? const SizedBox.shrink()),
    home: const LoginPage(),
  );
}
