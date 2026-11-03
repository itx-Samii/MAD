import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/student.dart';
import '../theme/app_theme.dart';

class ProjectsPage extends StatelessWidget {
  final Student student;
  const ProjectsPage({super.key, required this.student});

  static const _skills = [
    'Flutter & Dart',
    'Firebase',
    'REST APIs',
    'Git / GitHub',
    'UI/UX Design',
    'OOP & Data Structures',
  ];
  static const _projects = [
    (
      Icons.payments_outlined,
      'Fee Management System',
      'Manage student fees, track payments, and monitor outstanding balances.',
    ),
    (
      Icons.fact_check_outlined,
      'Attendance Management System',
      'Record student attendance and view daily and monthly attendance reports.',
    ),
    (
      Icons.inventory_2_outlined,
      'Inventory Management System',
      'Manage products, track stock levels, and record incoming and outgoing items.',
    ),
  ];

  Future<void> _copyPhone(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: student.phone));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Phone number copied')));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Skills & projects')),
    body: SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  student.name,
                  style: const TextStyle(
                    color: PortalColors.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Skills',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 7,
                          runSpacing: 7,
                          children: [
                            for (final skill in _skills)
                              Chip(
                                label: Text(
                                  skill,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: PortalColors.primary,
                                  ),
                                ),
                                backgroundColor: PortalColors.tint,
                                side: BorderSide.none,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'My projects',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 16),
                        for (final (index, (icon, title, description))
                            in _projects.indexed) ...[
                          if (index > 0)
                            const Divider(height: 28, color: PortalColors.line),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: PortalColors.tint,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  icon,
                                  color: PortalColors.primary,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      description,
                                      style: const TextStyle(
                                        color: PortalColors.muted,
                                        fontSize: 12,
                                        height: 1.5,
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
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.phone_outlined,
                      color: PortalColors.primary,
                    ),
                    title: const Text('Phone', style: TextStyle(fontSize: 12)),
                    subtitle: Text(student.phone),
                    trailing: const Icon(Icons.copy_outlined, size: 18),
                    onTap: () => _copyPhone(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
