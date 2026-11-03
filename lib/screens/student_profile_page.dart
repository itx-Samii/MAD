import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/student.dart';
import '../navigation/fade_route.dart';
import '../theme/app_theme.dart';
import 'login_page.dart';
import 'projects_page.dart';

class StudentProfilePage extends StatelessWidget {
  final Student student;
  const StudentProfilePage({super.key, required this.student});

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout?'),
        content: const Text('You can sign in again with your student account.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      fadeRoute<void>(context, const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('My profile'),
      automaticallyImplyLeading: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      actions: [
        TextButton.icon(
          onPressed: () => Navigator.of(context)
              .push(fadeRoute<void>(context, ProjectsPage(student: student))),
          icon: const Icon(Icons.work_outline_rounded, size: 18),
          label: const Text('Projects'),
        ),
        IconButton(
          tooltip: 'Logout',
          onPressed: () => _logout(context),
          icon: const Icon(Icons.logout_rounded, size: 21),
        ),
        const SizedBox(width: 4),
      ],
    ),
    body: SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProfileHeader(student: student),
                const SizedBox(height: 10),
                _PersonalInformation(student: student),
                const SizedBox(height: 10),
                _AboutSection(student: student),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _ProfileHeader extends StatefulWidget {
  final Student student;
  const _ProfileHeader({required this.student});

  @override
  State<_ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<_ProfileHeader> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    key: const ValueKey('profile-header'),
    duration: motionDuration(context),
    curve: Curves.easeInOutCubic,
    padding: EdgeInsets.all(_expanded ? 16 : 12),
    decoration: PortalTheme.cardDecoration(highlighted: _expanded),
    child: Row(
      children: [
        Semantics(
          button: true,
          toggled: _expanded,
          label: _expanded
              ? 'Make profile photo smaller'
              : 'Enlarge profile photo',
          child: InkWell(
            key: const ValueKey('profile-photo-button'),
            borderRadius: BorderRadius.circular(90),
            onTap: () => setState(() => _expanded = !_expanded),
            child: AnimatedContainer(
              key: const ValueKey('profile-avatar'),
              duration: motionDuration(context),
              curve: Curves.easeInOutCubic,
              width: _expanded ? 150 : 110,
              height: _expanded ? 150 : 110,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: PortalColors.primary, width: 2),
              ),
              child: ClipOval(
                child: Image.asset(
                  widget.student.photo,
                  key: const ValueKey('profile-photo'),
                  fit: BoxFit.cover,
                  semanticLabel: widget.student.name,
                  errorBuilder: (context, error, stackTrace) => ColoredBox(
                    color: PortalColors.tint,
                    child: Center(
                      child: Text(
                        widget.student.name
                            .split(' ')
                            .where((s) => s.isNotEmpty)
                            .take(2)
                            .map((part) => part[0])
                            .join(),
                        style: const TextStyle(
                          color: PortalColors.primary,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.student.name,
                key: const ValueKey('student-name'),
                style: const TextStyle(
                  color: PortalColors.ink,
                  fontSize: 19,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                'Role: ${widget.student.role}',
                style: const TextStyle(
                  color: PortalColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                _expanded ? 'Tap photo to reduce' : 'Tap photo to enlarge',
                style: const TextStyle(
                  color: PortalColors.muted,
                  fontSize: 10,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _PersonalInformation extends StatefulWidget {
  final Student student;
  const _PersonalInformation({required this.student});

  @override
  State<_PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<_PersonalInformation> {
  bool _hidden = false;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Personal information',
                  style: TextStyle(
                    color: PortalColors.ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => setState(() => _hidden = !_hidden),
                icon: Icon(
                  _hidden
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 17,
                ),
                label: Text(_hidden ? 'Show' : 'Hide'),
              ),
            ],
          ),
          AnimatedOpacity(
            key: const ValueKey('personal-information-details'),
            opacity: _hidden ? 0 : 1,
            duration: motionDuration(context),
            curve: Curves.easeInOut,
            child: IgnorePointer(
              ignoring: _hidden,
              child: ExcludeSemantics(
                excluding: _hidden,
                child: Column(
                  children: [
                    _InfoRow(
                      Icons.badge_outlined,
                      'SAP ID',
                      widget.student.sapId,
                    ),
                    _InfoRow(
                      Icons.mail_outline_rounded,
                      'Email',
                      widget.student.email,
                      copyable: true,
                    ),
                    _InfoRow(
                      Icons.account_balance_outlined,
                      'University',
                      widget.student.university,
                    ),
                    _InfoRow(
                      Icons.school_outlined,
                      'Program',
                      widget.student.program,
                    ),
                    _InfoRow(
                      Icons.calendar_month_outlined,
                      'Semester',
                      widget.student.semester,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool copyable;
  const _InfoRow(this.icon, this.label, this.value, {this.copyable = false});

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$label copied')));
  }

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(minHeight: 38),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: PortalColors.tint,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 17, color: PortalColors.primary),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: PortalColors.muted,
                    fontSize: 10,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: PortalColors.ink,
                    fontSize: 12,
                    height: 1.3,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (copyable)
            IconButton(
              tooltip: 'Copy ${label.toLowerCase()}',
              onPressed: () => _copy(context),
              icon: const Icon(
                Icons.copy_outlined,
                size: 17,
                color: PortalColors.primary,
              ),
            ),
        ],
      ),
    ),
  );
}

class _AboutSection extends StatefulWidget {
  final Student student;
  const _AboutSection({required this.student});

  @override
  State<_AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<_AboutSection> {
  bool _expanded = false;
  static const _style = TextStyle(
    color: PortalColors.muted,
    fontSize: 12,
    height: 1.5,
  );

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'About me',
            style: TextStyle(
              color: PortalColors.ink,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          if (MediaQuery.disableAnimationsOf(context))
            Text(
              widget.student.about,
              maxLines: _expanded ? null : 2,
              overflow: _expanded ? TextOverflow.clip : TextOverflow.ellipsis,
              style: _style,
            )
          else
            AnimatedCrossFade(
              key: const ValueKey('about-me-cross-fade'),
              firstChild: Text(
                widget.student.about,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: _style,
              ),
              secondChild: Text(widget.student.about, style: _style),
              crossFadeState: _expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: motionDuration(context),
              firstCurve: Curves.easeInOut,
              secondCurve: Curves.easeInOut,
              sizeCurve: Curves.easeInOutCubic,
              alignment: Alignment.topLeft,
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => setState(() => _expanded = !_expanded),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              icon: Icon(
                _expanded ? Icons.expand_less : Icons.expand_more,
                size: 18,
              ),
              label: Text(_expanded ? 'Show less' : 'Read more'),
            ),
          ),
        ],
      ),
    ),
  );
}
