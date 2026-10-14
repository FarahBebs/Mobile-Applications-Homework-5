// Student: Farah Alhasan
// Student Number: 21120205709
//
// UBYS-style instant message / e-mail dialog.
// This is only a UI design: nothing is really sent. Pressing "Send" simulates
// a network request with Future.delayed and then closes the dialog.

import 'package:flutter/material.dart';

enum MessageMode { message, email }

/// Opens the dialog. Returns how the message was sent, or null if cancelled.
Future<MessageMode?> showMessageDialog(
  BuildContext context, {
  required Map<String, String> recipient,
  MessageMode initialMode = MessageMode.message,
}) {
  return showDialog<MessageMode>(
    context: context,
    barrierDismissible: false,
    builder: (_) =>
        MessageDialog(recipient: recipient, initialMode: initialMode),
  );
}

class MessageDialog extends StatefulWidget {
  final Map<String, String> recipient;
  final MessageMode initialMode;

  const MessageDialog({
    super.key,
    required this.recipient,
    this.initialMode = MessageMode.message,
  });

  @override
  State<MessageDialog> createState() => _MessageDialogState();
}

class _MessageDialogState extends State<MessageDialog> {
  static const List<String> _categories = [
    'General',
    'Course',
    'Exam',
    'Assignment',
    'Other',
  ];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  late MessageMode _mode = widget.initialMode;
  String _category = _categories.first;
  bool _sendCopy = false;
  bool _isSending = false;

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSending = true;
    });

    // Simulated request - the message is not really sent.
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    Navigator.of(context).pop(_mode);
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isEmail = _mode == MessageMode.email;
    final user = widget.recipient;

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header bar
            Container(
              color: colors.primary,
              padding: const EdgeInsets.fromLTRB(20, 12, 8, 12),
              child: Row(
                children: [
                  Icon(
                    isEmail ? Icons.email_outlined : Icons.chat_outlined,
                    color: colors.onPrimary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isEmail ? 'New E-mail' : 'New Message',
                      style: textTheme.titleLarge?.copyWith(
                        color: colors.onPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: _isSending
                        ? null
                        : () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: colors.onPrimary),
                  ),
                ],
              ),
            ),

            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Message / E-mail switch
                      SegmentedButton<MessageMode>(
                        segments: const [
                          ButtonSegment(
                            value: MessageMode.message,
                            icon: Icon(Icons.chat_bubble_outline),
                            label: Text('Message'),
                          ),
                          ButtonSegment(
                            value: MessageMode.email,
                            icon: Icon(Icons.alternate_email),
                            label: Text('E-mail'),
                          ),
                        ],
                        selected: {_mode},
                        onSelectionChanged: _isSending
                            ? null
                            : (selection) {
                                setState(() {
                                  _mode = selection.first;
                                });
                              },
                      ),

                      const SizedBox(height: 16),

                      // Recipient
                      Container(
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user['avatar']!),
                            onBackgroundImageError: (_, _) {},
                          ),
                          title: Text('To: ${user['name']}'),
                          subtitle: Text(
                            isEmail ? user['email']! : user['title']!,
                          ),
                          trailing: Icon(
                            isEmail ? Icons.mail_outline : Icons.circle,
                            size: isEmail ? 20 : 12,
                            color: isEmail ? colors.outline : Colors.green,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        initialValue: _category,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          prefixIcon: Icon(Icons.label_outline),
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          for (final category in _categories)
                            DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ),
                        ],
                        onChanged: _isSending
                            ? null
                            : (value) {
                                setState(() {
                                  _category = value!;
                                });
                              },
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _subjectController,
                        enabled: !_isSending,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Subject',
                          prefixIcon: Icon(Icons.subject),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Please enter a subject'
                            : null,
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _bodyController,
                        enabled: !_isSending,
                        minLines: 5,
                        maxLines: 8,
                        maxLength: 1000,
                        decoration: InputDecoration(
                          labelText: isEmail ? 'E-mail' : 'Message',
                          hintText: 'Write your message here...',
                          alignLabelWithHint: true,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.trim().length < 10
                            ? 'The message must be at least 10 characters'
                            : null,
                      ),

                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        value: _sendCopy,
                        onChanged: _isSending
                            ? null
                            : (value) {
                                setState(() {
                                  _sendCopy = value ?? false;
                                });
                              },
                        title: const Text('Send a copy to my e-mail'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Divider(height: 1),

            // Actions
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSending
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: _isSending ? null : _send,
                    icon: _isSending
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                    label: Text(_isSending ? 'Sending...' : 'Send'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
