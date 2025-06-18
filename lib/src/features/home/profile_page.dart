import 'package:flutter/material.dart';
import 'package:test1/src/core/shared_prefs.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final email = SharedPrefs.getEmail() ?? 'Not set';
    final password = SharedPrefs.getPassword() ?? 'Not set';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.teal,
        centerTitle: true,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
        child: Column(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: Colors.teal.shade100,
              child: Icon(Icons.person, size: 48, color: Colors.teal.shade700),
            ),
            const SizedBox(height: 24),
            Text(
              'Your Profile Info',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.teal.shade800,
              ),
            ),
            const SizedBox(height: 32),

            // Info block
            _InfoRow(label: 'Email', value: email),
            const SizedBox(height: 20),
            _InfoRow(label: 'Password', value: password),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade900,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
