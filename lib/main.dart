import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

const _ink = Color(0xff2c2540);
const _primary = Color(0xff6545c1);
const _paper = Color(0xfff8f6fd);
const _muted = Color(0xff706980);
const _line = Color(0xffe3ddef);
const _accent = Color(0xff7557cc);
const _accentTint = Color(0xfff0eafa);
const _onPrimary = Color(0xffeee7ff);
const _danger = Color(0xffb3261e);

/// Content never grows wider than a large phone, so tablets and the web keep
/// the mobile layout centred instead of stretching it.
const _maxWidth = 520.0;
const _studentDomain = 'students.riphah.edu.pk';

final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

// ----------------------------------------------------
// MY DETAILS
// ----------------------------------------------------
const _name = 'Sameer Abdullah';
const _degree = 'BS Software Engineering';
const _phone = '0349 5999656';
const _campus = 'Riphah International University, I-14';
const _photo = 'image/profile.jpg';
const _intro =
    "Hi! I'm Sameer, a Software Engineering student at Riphah International "
    'University, I-14. I enjoy building mobile apps with Flutter and like '
    'learning something new every day.';

const _skills = [
  'Flutter & Dart',
  'Firebase',
  'REST APIs',
  'Git / GitHub',
  'UI/UX Design',
  'OOP & Data Structures',
];

const _projects = [
  (
  Icons.payments_outlined,
  'Fee Management System',
  'Manage student fees, track payments, and monitor outstanding balances.'
  ),
  (
  Icons.fact_check_outlined,
  'Attendance Management System',
  'Record student attendance and view daily and monthly attendance reports.'
  ),
  (
  Icons.inventory_2_outlined,
  'Inventory Management System',
  'Manage products, track stock levels, and record incoming and outgoing items.'
  ),
];

OutlineInputBorder _fieldBorder([Color color = _line, double width = 1]) =>
    OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: width),
    );

void _toast(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: _name,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: _paper,
      colorScheme: ColorScheme.fromSeed(seedColor: _primary).copyWith(
        primary: _primary,
        onPrimary: Colors.white,
        secondary: _accent,
        primaryContainer: _accentTint,
        onPrimaryContainer: _ink,
        surface: Colors.white,
        onSurface: _ink,
        onSurfaceVariant: _muted,
        outline: _line,
        error: _danger,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: _primary,
        selectionColor: Color(0x336545c1),
        selectionHandleColor: _primary,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        prefixIconColor: _muted,
        labelStyle: const TextStyle(color: _muted, fontSize: 14),
        errorMaxLines: 2,
        border: _fieldBorder(),
        enabledBorder: _fieldBorder(),
        focusedBorder: _fieldBorder(_accent, 2),
        errorBorder: _fieldBorder(_danger),
        focusedErrorBorder: _fieldBorder(_danger, 2),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 52),
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          textStyle:
          const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: _primary,
        contentTextStyle:
        const TextStyle(color: Colors.white, fontSize: 14),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    // Wraps the Navigator, so dialogs and snackbars stay inside the phone
    // frame too.
    builder: (context, child) =>
        _MobilePreview(child: child ?? const SizedBox.shrink()),
    home: const LoginPage(),
  );
}

// ----------------------------------------------------
// MOBILE PREVIEW (web)
// ----------------------------------------------------

/// On the web, a large browser window shows the app inside a phone frame so
/// it looks the way it does on a phone. Native builds and small windows (a
/// phone's own browser) render full screen as usual.
class _MobilePreview extends StatelessWidget {
  static const _screen = Size(390, 844);
  static const _bezel = 12.0;
  static const _radius = 46.0;
  static const _statusBar = 47.0;
  static const _homeBar = 21.0;

  final Widget child;
  const _MobilePreview({required this.child});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    if (!kIsWeb || media.size.shortestSide < 600) return child;

    const insets = EdgeInsets.only(top: _statusBar, bottom: _homeBar);
    return ColoredBox(
      color: const Color(0xffeeebf5),
      child: Padding(
        padding: const EdgeInsets.all(24),
        // Shrinks the phone to fit short windows; never enlarges it.
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xff0d1117),
              borderRadius: BorderRadius.circular(_radius + _bezel),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x256545c1),
                  blurRadius: 48,
                  offset: Offset(0, 24),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(_bezel),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_radius),
                child: SizedBox.fromSize(
                  size: _screen,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // The app sees a phone-sized screen with a status bar
                      // and home indicator, so SafeArea and AppBar pad for them.
                      MediaQuery(
                        data: media.copyWith(
                          size: _screen,
                          padding: insets,
                          viewPadding: insets,
                        ),
                        child: child,
                      ),
                      const IgnorePointer(
                        child: Stack(
                          children: [
                            Positioned(
                              top: 11,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: _Pill(
                                    width: 120, height: 34, color: Colors.black),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: _Pill(
                                    width: 134,
                                    height: 5,
                                    color: Color(0x99000000)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final double width, height;
  final Color color;
  const _Pill({required this.width, required this.height, required this.color});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    height: height,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(height / 2),
      ),
    ),
  );
}

// ----------------------------------------------------
// SHARED LAYOUT PIECES
// ----------------------------------------------------

/// Centres [child] and caps it at [_maxWidth].
class _Frame extends StatelessWidget {
  final Widget child;
  const _Frame({required this.child});

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    heightFactor: 1,
    child: SizedBox(width: _maxWidth, child: child),
  );
}

/// A white card with a heading.
class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    elevation: 1,
    shadowColor: const Color(0x146545c1),
    // Material rather than a plain Container so ink ripples stay visible.
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(color: _line),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            child: Text(title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700, color: _ink)),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    ),
  );
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
    child: Text(
      '© ${DateTime.now().year} $_name',
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 12, color: _muted),
    ),
  );
}

// ----------------------------------------------------
// LOGIN PAGE
// ----------------------------------------------------
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();
  final _id = TextEditingController();
  final _password = TextEditingController();
  bool _hidden = true;

  @override
  void dispose() {
    _id.dispose();
    _password.dispose();
    super.dispose();
  }

  String? _validateId(String? value) {
    final id = (value ?? '').trim();
    if (id.isEmpty) return 'Enter your student email or SAP ID.';
    final isSapId = RegExp(r'^\d+$').hasMatch(id);
    return isSapId || _emailPattern.hasMatch(id)
        ? null
        : 'Enter a valid student email or numeric SAP ID.';
  }

  void _login() {
    if (!_form.currentState!.validate()) return;
    final id = _id.text.trim();
    FocusScope.of(context).unfocus();
    Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
      builder: (_) => PortfolioPage(
        // A bare SAP ID is shown as the matching student email.
        email: id.contains('@') ? id : '$id@$_studentDomain',
      ),
    ));
  }

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle.dark,
    child: Scaffold(
      backgroundColor: _paper,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
          child: _Frame(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: _primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.school_rounded,
                          color: Colors.white, size: 25),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Riphah',
                              style: TextStyle(
                                  color: _primary,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700)),
                          Text('STUDENT PORTFOLIO',
                              style: TextStyle(
                                  color: _muted,
                                  fontSize: 9,
                                  letterSpacing: 1.8,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 44),
                _buildForm(),
                const SizedBox(height: 32),
                const Divider(height: 1, color: _line),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Icon(Icons.account_balance_outlined, color: _muted, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Riphah International University\nI-14 Campus, Islamabad',
                        style: TextStyle(color: _muted, fontSize: 12, height: 1.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  InputDecoration _loginDecoration(String label, IconData icon,
          {String? hintText, Widget? suffixIcon}) =>
      InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: _muted, fontSize: 14),
        hintText: hintText,
        hintStyle: const TextStyle(color: _muted, fontSize: 13),
        floatingLabelStyle: const TextStyle(
            color: _accent, fontSize: 13, fontWeight: FontWeight.w600),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, color: _accent, size: 21),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 17),
        enabledBorder: _fieldBorder(_line),
        focusedBorder: _fieldBorder(_accent, 1.5),
      );

  Widget _buildForm() => Form(
    key: _form,
    child: AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Icon(Icons.circle, size: 7, color: _accent),
              SizedBox(width: 8),
              Text('STUDENT LOGIN',
                  style: TextStyle(
                      color: _accent,
                      fontSize: 10,
                      letterSpacing: 1.8,
                      fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 14),
          Semantics(
            header: true,
            child: const Text(
              'Your portfolio,\nall in one place.',
              style: TextStyle(
                  fontSize: 34,
                  height: 1.15,
                  letterSpacing: -1,
                  fontWeight: FontWeight.w700,
                  color: _ink),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Sign in to explore your profile, skills and projects.',
            style: TextStyle(color: _muted, fontSize: 14, height: 1.6),
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: _id,
            cursorColor: _accent,
            style: const TextStyle(color: _ink, fontSize: 14),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.username],
            autocorrect: false,
            enableSuggestions: false,
            decoration: _loginDecoration('Email or SAP ID', Icons.person_outline,
                hintText: 'Your university email or SAP ID'),
            validator: _validateId,
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _password,
            cursorColor: _accent,
            style: const TextStyle(color: _ink, fontSize: 14),
            obscureText: _hidden,
            autocorrect: false,
            enableSuggestions: false,
            autofillHints: const [AutofillHints.password],
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _login(),
            decoration: _loginDecoration(
              'Password',
              Icons.lock_outline_rounded,
              hintText: 'Enter your password',
              suffixIcon: IconButton(
                color: _muted,
                tooltip: _hidden ? 'Show password' : 'Hide password',
                onPressed: () => setState(() => _hidden = !_hidden),
                icon: Icon(
                  _hidden
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                ),
              ),
            ),
            validator: (value) => (value ?? '').length < 4
                ? 'Password must be at least 4 characters.'
                : null,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _login,
            style: FilledButton.styleFrom(
              backgroundColor: _primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(64, 54),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Open my portfolio'),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_rounded, size: 19),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// ----------------------------------------------------
// PORTFOLIO PAGE
// ----------------------------------------------------
class PortfolioPage extends StatelessWidget {
  final String email;
  const PortfolioPage({super.key, required this.email});

  Future<void> _signOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('Sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: _danger),
            onPressed: () => Navigator.pop(dialog, true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
      builder: (_) => const LoginPage(),
    ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      foregroundColor: _primary,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      automaticallyImplyLeading: false,
      title: const Text('My Portfolio',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      actions: [
        IconButton(
          tooltip: 'Sign out',
          style: IconButton.styleFrom(
            backgroundColor: _accentTint,
            foregroundColor: _primary,
          ),
          onPressed: () => _signOut(context),
          icon: const Icon(Icons.logout_rounded),
        ),
        const SizedBox(width: 6),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, thickness: 1, color: _line),
      ),
    ),
    body: SingleChildScrollView(
      child: _Frame(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ProfileCard(email: email),
              const SizedBox(height: 14),
              const _Section(
                title: 'About me',
                child: Text(_intro,
                    style:
                    TextStyle(color: _muted, fontSize: 14.5, height: 1.6)),
              ),
              const SizedBox(height: 14),
              const _Section(title: 'Skills', child: _SkillsList()),
              const SizedBox(height: 14),
              const _Projects(),
              const SizedBox(height: 14),
              const _ContactSection(),
              const SizedBox(height: 12),
              const SafeArea(top: false, child: _Footer()),
            ],
          ),
        ),
      ),
    ),
  );
}

// ----------------------------------------------------
// PROFILE CARD
// ----------------------------------------------------
class _ProfileCard extends StatelessWidget {
  final String email;
  const _ProfileCard({required this.email});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xff5636a6), Color(0xff8463d7)],
      ),
      borderRadius: BorderRadius.circular(24),
      boxShadow: const [
        BoxShadow(
          color: Color(0x266545c1),
          blurRadius: 20,
          offset: Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      children: [
        const _Avatar(),
        const SizedBox(height: 14),
        const Text(
          _name,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        const Text(
          _degree,
          textAlign: TextAlign.center,
          style: TextStyle(color: _onPrimary, fontSize: 14, height: 1.4),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.mail_outline_rounded, size: 16, color: _onPrimary),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                email,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _Avatar extends StatelessWidget {
  static const size = 110.0;
  const _Avatar();

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    padding: const EdgeInsets.all(3),
    decoration:
    const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
    child: ClipOval(
      child: Image.asset(
        _photo,
        fit: BoxFit.cover,
        semanticLabel: _name,
        errorBuilder: (context, error, stackTrace) => const ColoredBox(
          color: _accent,
          child: Center(
            child: Text('SA',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    ),
  );
}

// ----------------------------------------------------
// PORTFOLIO SECTIONS
// ----------------------------------------------------
class _SkillsList extends StatelessWidget {
  const _SkillsList();

  @override
  Widget build(BuildContext context) =>
      Wrap(spacing: 8, runSpacing: 8, children: [
        for (final skill in _skills)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: _accentTint,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              skill,
              style: const TextStyle(
                fontSize: 12.5,
                color: _accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ]);
}

class _Projects extends StatelessWidget {
  const _Projects();

  @override
  Widget build(BuildContext context) => _Section(
    title: 'My projects',
    child: Column(
      children: [
        for (final (index, (icon, title, description))
        in _projects.indexed) ...[
          if (index > 0) const Divider(height: 28, color: _line),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _accentTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: _accent, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15.5,
                        height: 1.3,
                        color: _ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 13.5,
                        height: 1.5,
                        color: _muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    ),
  );
}

class _ContactSection extends StatelessWidget {
  const _ContactSection();

  @override
  Widget build(BuildContext context) => const _Section(
    title: 'Contact',
    child: Column(
      children: [
        _ContactTile(Icons.location_on_outlined, 'Campus', _campus),
        Divider(height: 1, color: _line),
        _ContactTile(Icons.phone_outlined, 'Phone', _phone),
        Divider(height: 1, color: _line),
        _ContactTile(
          Icons.language_rounded,
          'University website',
          'www.riphah.edu.pk',
        ),
      ],
    ),
  );
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _ContactTile(this.icon, this.label, this.value);

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (context.mounted) _toast(context, '$label copied');
  }

  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(10),
    onTap: () => _copy(context),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _accentTint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: _accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(color: _muted, fontSize: 12)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: _ink,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.5,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.copy_rounded, size: 17, color: _muted),
        ],
      ),
    ),
  );
}
