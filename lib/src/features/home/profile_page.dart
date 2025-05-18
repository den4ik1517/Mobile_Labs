import 'package:flutter/material.dart';
import 'package:test1/src/core/shared_prefs.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<Map<String, String>> _loadUserData() async {
    final email = await SharedPrefs.getEmail() ?? 'N/A';
    final password = await SharedPrefs.getPassword() ?? 'N/A';
    return {
      'email': email,
      'password': password,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<Map<String, String>>(
        future: _loadUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.deepPurple.shade200,
                  child: const Icon(Icons.person,
                      size: 80, color: Colors.white,),
                ),
                const SizedBox(height: 24),

                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  shadowColor: Colors.deepPurple.withOpacity(0.3),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _InfoRow(
                          icon: Icons.email,
                          label: 'Email',
                          value: data['email']!,
                          valueStyle: theme.textTheme.bodyLarge?.copyWith
                            (color: Colors.deepPurple),
                        ),
                        const Divider(height: 30, thickness: 1),
                        _InfoRow(
                          icon: Icons.lock,
                          label: 'Password',
                          value: data['password']!,
                          valueStyle: theme.textTheme.bodyLarge?.copyWith
                            (color: Colors.deepPurple),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: valueStyle ?? Theme.of(context).textTheme.bodyLarge,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
