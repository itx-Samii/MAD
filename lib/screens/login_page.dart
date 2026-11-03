import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/student_accounts.dart';
import '../navigation/fade_route.dart';
import '../theme/app_theme.dart';
import 'student_profile_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _passwordFocus = FocusNode(debugLabel: 'Password');
  bool _hidden = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = (value ?? '').trim();
    if (email.isEmpty) return 'Enter your university email.';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  void _clearError(String value) {
    if (_error != null) setState(() => _error = null);
  }

  Future<void> _login() async {
    if (_loading) return;
    setState(() => _error = null);
    if (!_form.currentState!.validate()) return;
    final email = _email.text;
    final password = _password.text;
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    final student = await DemoStudentAccounts.signIn(email, password);
    if (!mounted) return;
    if (student == null) {
      setState(() {
        _loading = false;
        _error = "We couldn't sign you in. Check your email and password.";
      });
      return;
    }
    setState(() => _loading = false);
    Navigator.of(context).pushReplacement(
      fadeRoute<void>(context, StudentProfilePage(student: student)),
    );
  }

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle.light,
    child: Scaffold(
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                28,
                MediaQuery.paddingOf(context).top + 28,
                28,
                48,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    PortalColors.gradientStart,
                    PortalColors.gradientEnd,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(48),
                  bottomRight: Radius.circular(22),
                ),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 464),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.account_balance_rounded,
                              color: PortalColors.primary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Text(
                              'Riphah',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        'Student Portal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Your university profile, in one place.',
                        style: TextStyle(
                          color: PortalColors.onPrimary,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(22),
                            child: _buildForm(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const SafeArea(
                          top: false,
                          child: Text(
                            'Riphah International University · I-14 Campus',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: PortalColors.muted,
                              fontSize: 11,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildForm() => Form(
    key: _form,
    child: AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Welcome back',
            style: TextStyle(
              color: PortalColors.ink,
              fontSize: 23,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Sign in with your student account.',
            style: TextStyle(color: PortalColors.muted, fontSize: 13),
          ),
          const SizedBox(height: 24),
          TextFormField(
            key: const ValueKey('login-email'),
            controller: _email,
            enabled: !_loading,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
            autofillHints: const [AutofillHints.username],
            autocorrect: false,
            enableSuggestions: false,
            onChanged: _clearError,
            decoration: const InputDecoration(
              labelText: 'University email',
              hintText: 'you@students.riphah.edu.pk',
              prefixIcon: Icon(Icons.alternate_email_rounded, size: 21),
            ),
            validator: _validateEmail,
          ),
          const SizedBox(height: 18),
          TextFormField(
            key: const ValueKey('login-password'),
            controller: _password,
            focusNode: _passwordFocus,
            enabled: !_loading,
            obscureText: _hidden,
            autocorrect: false,
            enableSuggestions: false,
            autofillHints: const [AutofillHints.password],
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _login(),
            onChanged: _clearError,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 21),
              suffixIcon: IconButton(
                tooltip: _hidden ? 'Show password' : 'Hide password',
                onPressed: _loading
                    ? null
                    : () => setState(() => _hidden = !_hidden),
                icon: Icon(
                  _hidden
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 21,
                ),
              ),
            ),
            validator: (value) =>
                (value ?? '').isEmpty ? 'Enter your password.' : null,
          ),
          if (_error != null) ...[
            const SizedBox(height: 14),
            Semantics(
              liveRegion: true,
              child: Container(
                key: const ValueKey('login-error'),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _error!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 22),
          FilledButton(
            key: const ValueKey('login-submit'),
            onPressed: _loading ? null : _login,
            child: Semantics(
              liveRegion: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_loading) ...[
                    const SizedBox(
                      key: ValueKey('login-spinner'),
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Flexible(
                    child: Text(
                      _loading ? 'Signing in…' : 'Login',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (!_loading) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 19),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
