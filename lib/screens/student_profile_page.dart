import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/student.dart';
import '../navigation/fade_route.dart';
import '../theme/app_theme.dart';
import '../widgets/portfolio_sections.dart';
import 'login_page.dart';

class StudentProfilePage extends StatefulWidget {
  final Student student;
  const StudentProfilePage({super.key, required this.student});

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  final _scrollController = ScrollController();
  final _bodyKey = GlobalKey();
  final _sectionKeys = List.generate(4, (_) => GlobalKey());
  int _selectedSection = 0;
  int _navigationRequest = 0;
  bool _scrollingToSection = false;
  bool _scrollUpdateScheduled = false;

  Student get student => widget.student;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _goToSection(int index) async {
    final target = _sectionKeys[index].currentContext;
    if (target == null) return;
    final request = ++_navigationRequest;
    _scrollingToSection = true;
    setState(() => _selectedSection = index);
    await Scrollable.ensureVisible(
      target,
      duration: motionDuration(context),
      curve: Curves.easeInOutCubic,
      alignment: 0,
    );
    if (!mounted || request != _navigationRequest) return;
    _scrollingToSection = false;
  }

  void _handleScroll() {
    if (_scrollingToSection || _scrollUpdateScheduled) return;
    _scrollUpdateScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollUpdateScheduled = false;
      if (!mounted || _scrollingToSection || !_scrollController.hasClients) {
        return;
      }
      final viewport = _bodyKey.currentContext?.findRenderObject();
      if (viewport is! RenderBox || !viewport.hasSize) return;
      var selected = 0;
      for (var index = 0; index < _sectionKeys.length; index++) {
        final section = _sectionKeys[index].currentContext?.findRenderObject();
        if (section is RenderBox &&
            section.hasSize &&
            section.localToGlobal(Offset.zero, ancestor: viewport).dy <= 24) {
          selected = index;
        }
      }
      final position = _scrollController.position;
      if (position.pixels > 0 && position.extentAfter <= 1) selected = 3;
      if (selected != _selectedSection) {
        setState(() => _selectedSection = selected);
      }
    });
  }

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
      title: const Text('My Portfolio'),
      automaticallyImplyLeading: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      actions: [
        IconButton(
          tooltip: 'Logout',
          style: IconButton.styleFrom(
            backgroundColor: PortalColors.tint,
            foregroundColor: PortalColors.primary,
          ),
          onPressed: () => _logout(context),
          icon: const Icon(Icons.logout_rounded),
        ),
        const SizedBox(width: 6),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, thickness: 1, color: PortalColors.line),
      ),
    ),
    body: Align(
      key: _bodyKey,
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                key: _sectionKeys[0],
                child: _ProfileHeader(student: student),
              ),
              const SizedBox(height: 14),
              _AboutSection(student: student),
              const SizedBox(height: 14),
              SizedBox(key: _sectionKeys[1], child: const SkillsSection()),
              const SizedBox(height: 14),
              SizedBox(key: _sectionKeys[2], child: const ProjectsSection()),
              const SizedBox(height: 14),
              SizedBox(
                key: _sectionKeys[3],
                child: _PersonalInformation(student: student),
              ),
              const SizedBox(height: 12),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Text(
                    '© ${DateTime.now().year} ${student.name}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: PortalColors.muted,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    bottomNavigationBar: DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: PortalColors.line)),
      ),
      child: NavigationBar(
        selectedIndex: _selectedSection,
        onDestinationSelected: _goToSection,
        destinations: const [
          NavigationDestination(
            key: ValueKey('nav-profile'),
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
          NavigationDestination(
            key: ValueKey('nav-skills'),
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school_rounded),
            label: 'Skills',
          ),
          NavigationDestination(
            key: ValueKey('nav-projects'),
            icon: Icon(Icons.work_outline_rounded),
            selectedIcon: Icon(Icons.work_rounded),
            label: 'Projects',
          ),
          NavigationDestination(
            key: ValueKey('nav-info'),
            icon: Icon(Icons.info_outline_rounded),
            selectedIcon: Icon(Icons.info_rounded),
            label: 'Info',
          ),
        ],
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
  Widget build(BuildContext context) => Semantics(
    button: true,
    toggled: _expanded,
    label: _expanded ? 'Collapse profile header' : 'Expand profile header',
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        key: const ValueKey('profile-photo-button'),
        onTap: () => setState(() => _expanded = !_expanded),
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          key: const ValueKey('profile-header'),
          duration: motionDuration(context),
          curve: Curves.easeInOutCubic,
          padding: _expanded
              ? const EdgeInsets.fromLTRB(24, 32, 24, 30)
              : const EdgeInsets.fromLTRB(20, 24, 20, 22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _expanded
                  ? const [PortalColors.expandedStart, PortalColors.expandedEnd]
                  : const [
                      PortalColors.gradientStart,
                      PortalColors.gradientEnd,
                    ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: PortalColors.cardShadow,
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              AnimatedContainer(
                key: const ValueKey('profile-avatar'),
                duration: motionDuration(context),
                curve: Curves.easeInOutCubic,
                width: _expanded ? 150 : 110,
                height: _expanded ? 150 : 110,
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    widget.student.photo,
                    key: const ValueKey('profile-photo'),
                    fit: BoxFit.cover,
                    semanticLabel: widget.student.name,
                    errorBuilder: (context, error, stackTrace) => ColoredBox(
                      color: PortalColors.primary,
                      child: Center(
                        child: Text(
                          widget.student.name
                              .split(' ')
                              .where((s) => s.isNotEmpty)
                              .take(2)
                              .map((part) => part[0])
                              .join(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                widget.student.name,
                key: const ValueKey('student-name'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.student.program,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: PortalColors.onPrimary,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.mail_outline_rounded,
                    size: 16,
                    color: PortalColors.onPrimary,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      widget.student.email,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      _expanded ? 'Tap to collapse' : 'Tap to expand',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: PortalColors.onPrimary,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: PortalColors.onPrimary,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
  Widget build(BuildContext context) => PortfolioSection(
    title: 'Personal information',
    action: TextButton.icon(
      onPressed: () => setState(() => _hidden = !_hidden),
      icon: Icon(
        _hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        size: 18,
      ),
      label: Text(_hidden ? 'Show' : 'Hide'),
    ),
    child: AnimatedOpacity(
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
              _InformationTile(
                Icons.person_outline,
                'Role',
                widget.student.role,
              ),
              const Divider(height: 1, color: PortalColors.line),
              _InformationTile(
                Icons.badge_outlined,
                'SAP ID',
                widget.student.sapId,
              ),
              const Divider(height: 1, color: PortalColors.line),
              _InformationTile(
                Icons.mail_outline_rounded,
                'Email',
                widget.student.email,
              ),
              const Divider(height: 1, color: PortalColors.line),
              _InformationTile(
                Icons.account_balance_outlined,
                'University',
                widget.student.university,
              ),
              const Divider(height: 1, color: PortalColors.line),
              _InformationTile(
                Icons.school_outlined,
                'Program',
                widget.student.program,
              ),
              const Divider(height: 1, color: PortalColors.line),
              _InformationTile(
                Icons.calendar_month_outlined,
                'Semester',
                widget.student.semester,
              ),
              const Divider(height: 1, color: PortalColors.line),
              _InformationTile(
                Icons.phone_outlined,
                'Phone',
                widget.student.phone,
              ),
              const Divider(height: 1, color: PortalColors.line),
              const _InformationTile(
                Icons.language_rounded,
                'University website',
                'www.riphah.edu.pk',
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _InformationTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InformationTile(this.icon, this.label, this.value);

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$label copied')));
  }

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => _copy(context),
    borderRadius: BorderRadius.circular(10),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: PortalColors.tint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: PortalColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: PortalColors.muted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: PortalColors.ink,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.copy_rounded, size: 17, color: PortalColors.muted),
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
    fontSize: 14.5,
    height: 1.6,
  );

  @override
  Widget build(BuildContext context) => PortfolioSection(
    title: 'About me',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
              size: 19,
            ),
            label: Text(_expanded ? 'Show less' : 'Read more'),
          ),
        ),
      ],
    ),
  );
}
