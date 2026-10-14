// Student: Farah Alhasan
// Student Number: 21120205709
//
// Profile page - the profile card from the lecture.

import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final bool isLoading;
  final Map<String, String>? userData;

  const ProfilePage({
    super.key,
    required this.isLoading,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    // Conditional rendering: loading -> indicator, no data -> text, else card
    return Center(
      child: isLoading
          ? const CircularProgressIndicator()
          : userData == null
          ? const Text('No data found.')
          : SingleChildScrollView(
              // Extra bottom padding so the buttons don't cover the card
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: _buildProfileCard(userData!),
              ),
            ),
    );
  }

  // Profile card widget
  Widget _buildProfileCard(Map<String, String> user) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user['avatar']!),
              onBackgroundImageError: (_, _) {},
            ),
            const SizedBox(height: 16),
            Text(
              user['name']!,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              user['title']!,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const Divider(height: 30, thickness: 1),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.deepPurple),
              title: const Text('E-mail'),
              subtitle: Text(user['email']!),
            ),
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.deepPurple),
              title: const Text('Location'),
              subtitle: Text(user['location']!),
            ),
          ],
        ),
      ),
    );
  }
}
