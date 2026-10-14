// Student: Farah Alhasan
// Student Number: 21120205709
//
// Mission & Vision page.

import 'package:flutter/material.dart';

class MissionVisionPage extends StatelessWidget {
  const MissionVisionPage({super.key});

  static const List<Map<String, Object>> _values = [
    {
      'icon': Icons.verified_outlined,
      'title': 'Quality',
      'text': 'Clean, tested and readable code.',
    },
    {
      'icon': Icons.lightbulb_outline,
      'title': 'Innovation',
      'text': 'Trying new tools and ideas.',
    },
    {
      'icon': Icons.groups_outlined,
      'title': 'Collaboration',
      'text': 'Learning and building together.',
    },
    {
      'icon': Icons.trending_up,
      'title': 'Growth',
      'text': 'Continuous learning every day.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _statementCard(
          context,
          icon: Icons.flag,
          title: 'Our Mission',
          text:
              'To teach students how to design and build modern, reliable '
              'and user-friendly mobile applications, and to give them the '
              'practical skills they need for the software industry.',
          background: colors.primaryContainer,
          foreground: colors.onPrimaryContainer,
        ),
        const SizedBox(height: 16),
        _statementCard(
          context,
          icon: Icons.visibility,
          title: 'Our Vision',
          text:
              'To be a leading learning community where every student can '
              'turn an idea into a published app that makes a positive '
              'difference in people\'s lives.',
          background: colors.tertiaryContainer,
          foreground: colors.onTertiaryContainer,
        ),
        const SizedBox(height: 24),
        Text('Core Values', style: textTheme.titleMedium),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            // Two columns on phones, four on wide screens
            final columns = constraints.maxWidth >= 700 ? 4 : 2;
            final itemWidth =
                (constraints.maxWidth - (columns - 1) * 12) / columns;

            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final value in _values)
                  SizedBox(
                    width: itemWidth,
                    child: Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              value['icon'] as IconData,
                              color: colors.primary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              value['title'] as String,
                              style: textTheme.titleSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              value['text'] as String,
                              style: textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _statementCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String text,
    required Color background,
    required Color foreground,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: foreground),
              const SizedBox(width: 8),
              Text(
                title,
                style: textTheme.titleLarge?.copyWith(color: foreground),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            text,
            style: textTheme.bodyLarge?.copyWith(
              color: foreground,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
