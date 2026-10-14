// Student: Farah Alhasan
// Student Number: 21120205709
//
// About page - biography, skills and experience.

import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  final Map<String, String>? userData;

  const AboutPage({super.key, required this.userData});

  static const List<String> _skills = [
    'Flutter',
    'Dart',
    'REST APIs',
    'State Management',
    'Firebase',
    'UI / UX Design',
    'Git',
  ];

  static const List<Map<String, String>> _experience = [
    {
      'title': 'Flutter Software Specialist',
      'place': 'Istanbul Medeniyet University',
      'years': '2021 - Present',
    },
    {
      'title': 'Mobile Developer',
      'place': 'Software Company',
      'years': '2018 - 2021',
    },
    {
      'title': 'B.Sc. Computer Engineering',
      'place': 'University',
      'years': '2014 - 2018',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final user = userData;
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _section(
          context,
          icon: Icons.person,
          title: 'Biography',
          child: Text(
            '${user['name']} is a ${user['title']} based in ${user['location']}. '
            'Teaching mobile application development and building '
            'cross-platform apps with Flutter, with a focus on clean '
            'architecture, good user experience and helping students '
            'turn ideas into real applications.',
            style: textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ),
        _section(
          context,
          icon: Icons.code,
          title: 'Skills',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final skill in _skills)
                Chip(
                  label: Text(skill),
                  backgroundColor: colors.secondaryContainer,
                  side: BorderSide.none,
                ),
            ],
          ),
        ),
        _section(
          context,
          icon: Icons.work_outline,
          title: 'Experience & Education',
          child: Column(
            children: [
              for (final item in _experience)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: colors.primaryContainer,
                    child: Icon(
                      Icons.school_outlined,
                      color: colors.onPrimaryContainer,
                    ),
                  ),
                  title: Text(item['title']!),
                  subtitle: Text('${item['place']}\n${item['years']}'),
                  isThreeLine: true,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _section(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: colors.primary),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
