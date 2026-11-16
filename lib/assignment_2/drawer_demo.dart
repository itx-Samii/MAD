import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class DrawerDemoApp extends StatelessWidget {
  const DrawerDemoApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Zain Khan Portal - Drawer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: PortalColors.background,
          colorScheme: ColorScheme.fromSeed(seedColor: PortalColors.primary),
        ),
        home: const DrawerHomePage(),
      );
}

class AppCard extends StatelessWidget {
  final Widget child;
  const AppCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: PortalColors.line),
          boxShadow: const [
            BoxShadow(
              color: PortalColors.cardShadow,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: child,
      );
}

class DrawerHomePage extends StatelessWidget {
  const DrawerHomePage({super.key});

  void openPage(BuildContext context, Widget page) {
    Navigator.pop(context); // Close the drawer
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Zain Khan Portal - Drawer'),
          backgroundColor: PortalColors.tint,
          elevation: 0,
          actions: [
            IconButton(
              tooltip: 'Close Demo',
              icon: const Icon(Icons.close_rounded, color: PortalColors.ink),
              onPressed: () => Navigator.of(context, rootNavigator: true).maybePop(),
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: PortalColors.background,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: const Text(
                  'Muhammad Zain Khan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                accountEmail: const Text('66157@students.riphah.edu.pk'),
                currentAccountPicture: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/profile.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'image/img.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, color: PortalColors.primary, size: 35),
                        ),
                      ),
                    ),
                  ),
                ),
                decoration: const BoxDecoration(
                  color: PortalColors.primary,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home, color: PortalColors.primary),
                title: const Text('Home'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.arrow_back_rounded, color: PortalColors.primary),
                title: const Text('Back to Assignments'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context, rootNavigator: true).maybePop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.school, color: PortalColors.primary),
                title: const Text('Academic Info'),
                onTap: () => openPage(
                  context,
                  const SimplePage(
                    title: 'Academic Info',
                    content: 'Program: BS Software Engineering (5th Semester)\nUniversity: Riphah International University',
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.auto_stories, color: PortalColors.primary),
                title: const Text('About Me'),
                onTap: () => openPage(
                  context,
                  const SimplePage(
                    title: 'About Me',
                    content: 'Software Engineering student specializing in Flutter Mobile App Development, DBMS, and Web Development.',
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.contact_mail, color: PortalColors.primary),
                title: const Text('Contact Details'),
                onTap: () => openPage(
                  context,
                  const SimplePage(
                    title: 'Contact Details',
                    content: 'Email: 66157@students.riphah.edu.pk\nLocation: Islamabad, Pakistan',
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings, color: PortalColors.muted),
                title: const Text('Settings'),
                onTap: () => openPage(
                  context,
                  const SimplePage(title: 'Settings', content: 'Application Settings'),
                ),
              ),
            ],
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: AppCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/profile.jpg',
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'image/img.png',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.person,
                          size: 80,
                          color: PortalColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Muhammad Zain Khan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: PortalColors.ink,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '66157@students.riphah.edu.pk',
                    style: TextStyle(
                      color: PortalColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Open the drawer using the menu icon above to navigate.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class SimplePage extends StatelessWidget {
  final String title;
  final String content;

  const SimplePage({super.key, required this.title, this.content = ''});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: PortalColors.tint,
          elevation: 0,
          leading: IconButton(
            tooltip: 'Back',
            icon: const Icon(Icons.arrow_back_rounded, color: PortalColors.ink),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: AppCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: PortalColors.ink,
                    ),
                  ),
                  if (content.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      content,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: PortalColors.muted,
                        height: 1.5,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PortalColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('Back to Drawer Menu'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
