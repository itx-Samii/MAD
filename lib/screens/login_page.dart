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
    final id = (value ?? '').trim();
    if (id.isEmpty) return 'Enter your student email or SAP ID.';
    if (!RegExp(r'^\d+$').hasMatch(id) &&
        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(id)) {
      return 'Enter a valid student email or numeric SAP ID.';
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
    value: SystemUiOverlayStyle.dark,
    child: Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: PortalColors.primary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.school_rounded,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Riphah',
                              style: TextStyle(
                                color: PortalColors.primary,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'STUDENT PORTFOLIO',
                              style: TextStyle(
                                color: PortalColors.muted,
                                fontSize: 9,
                                letterSpacing: 1.8,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 44),
                  _buildForm(),
                  const SizedBox(height: 32),
                  const Divider(height: 1, color: PortalColors.line),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Icon(
                        Icons.account_balance_outlined,
                        color: PortalColors.muted,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Riphah International University\nI-14 Campus, Islamabad',
                          style: TextStyle(
                            color: PortalColors.muted,
                            fontSize: 12,
                            height: 1.6,
                          ),
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
    ),
  );

  Widget _buildForm() => Form(
    key: _form,
    child: AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Icon(Icons.circle, size: 7, color: PortalColors.primary),
              SizedBox(width: 8),
              Text(
                'STUDENT LOGIN',
                style: TextStyle(
                  color: PortalColors.primary,
                  fontSize: 10,
                  letterSpacing: 1.8,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Semantics(
            header: true,
            child: const Text(
              'Your portfolio,\nall in one place.',
              style: TextStyle(
                color: PortalColors.ink,
                fontSize: 34,
                height: 1.15,
                letterSpacing: -1,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Sign in to explore your profile, skills and projects.',
            style: TextStyle(
              color: PortalColors.muted,
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),
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
              labelText: 'Email or SAP ID',
              hintText: 'Your university email or SAP ID',
              prefixIcon: Icon(Icons.person_outline, size: 21),
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
          const SizedBox(height: 24),
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
                      _loading ? 'Signing in…' : 'Open my portfolio',
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
