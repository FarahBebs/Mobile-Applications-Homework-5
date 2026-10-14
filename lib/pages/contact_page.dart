// Student: Farah Alhasan
// Student Number: 21120205709
//
// Contact page - contact details and shortcuts to the message dialog.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/message_dialog.dart';

class ContactPage extends StatelessWidget {
  final Map<String, String>? userData;
  final void Function(MessageMode mode) onSendMessage;

  const ContactPage({
    super.key,
    required this.userData,
    required this.onSendMessage,
  });

  @override
  Widget build(BuildContext context) {
    final user = userData;
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final colors = Theme.of(context).colorScheme;

    final details = [
      (Icons.email, 'E-mail', user['email']!),
      (Icons.phone, 'Phone', user['phone']!),
      (Icons.location_on, 'Location', user['location']!),
      (Icons.meeting_room, 'Office', user['office']!),
      (Icons.schedule, 'Office Hours', user['officeHours']!),
      (Icons.language, 'Website', user['website']!),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                for (final (icon, label, value) in details)
                  ListTile(
                    leading: Icon(icon, color: colors.primary),
                    title: Text(label),
                    subtitle: Text(value),
                    trailing: IconButton(
                      tooltip: 'Copy',
                      icon: const Icon(Icons.copy, size: 20),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: value));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$label copied.'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => onSendMessage(MessageMode.message),
          icon: const Icon(Icons.chat_outlined),
          label: const Text('Send Instant Message'),
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => onSendMessage(MessageMode.email),
          icon: const Icon(Icons.email_outlined),
          label: const Text('Send E-mail'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
          ),
        ),
      ],
    );
  }
}
