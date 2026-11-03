import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class PortfolioSection extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? action;
  const PortfolioSection({
    super.key,
    required this.title,
    required this.child,
    this.action,
  });

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: PortalColors.ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              ?action,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    ),
  );
}

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  static const _skills = [
    'Flutter & Dart',
    'Firebase',
    'REST APIs',
    'Git / GitHub',
    'UI/UX Design',
    'OOP & Data Structures',
  ];

  @override
  Widget build(BuildContext context) => PortfolioSection(
    title: 'Skills',
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final skill in _skills)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: PortalColors.tint,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              skill,
              style: const TextStyle(
                color: PortalColors.primary,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    ),
  );
}

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

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

  @override
  Widget build(BuildContext context) => PortfolioSection(
    title: 'My projects',
    child: Column(
      children: [
        for (final (index, (icon, title, description))
            in _projects.indexed) ...[
          if (index > 0) const Divider(height: 28, color: PortalColors.line),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: PortalColors.tint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: PortalColors.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: PortalColors.ink,
                        fontSize: 15.5,
                        height: 1.3,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        color: PortalColors.muted,
                        fontSize: 13.5,
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
  );
}
