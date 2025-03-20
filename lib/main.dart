import 'package:flutter/material.dart';

void main() {
  runApp(const LogisticsApp());
}

class LogisticsApp extends StatelessWidget {
  const LogisticsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Logistics App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/profile': (context) => const ProfilePage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

class User {
  static String name = '';
  static String email = '';
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const InputField(hintText: 'Email'),
            const InputField(hintText: 'Password', obscureText: true),
            ActionButton(
              text: 'Login',
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputField(controller: nameController, hintText: 'Name'),
            InputField(controller: emailController, hintText: 'Email'),
            InputField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),
            ActionButton(
              text: 'Register',
              onPressed: () {
                User.name = nameController.text;
                User.email = emailController.text;
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: Icon(Icons.account_circle, size: 100)),
            const SizedBox(height: 20),
            Text('Name: ${User.name}', style: const TextStyle(fontSize: 18)),
            Text('Email: ${User.email}', style: const TextStyle(fontSize: 18)),
            const Text('Role: Logistics Manager',
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            const Text(
              'Assigned Deliveries:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(title: Text('Package 1 - In Transit')),
                  ListTile(title: Text('Package 2 - Delivered')),
                  ListTile(title: Text('Package 3 - Pending Pickup')),
                ],
              ),
            ),
            ActionButton(
              text: 'Go to Home',
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Logistics Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Live Shipment Tracking',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              height: 200,
              color: Colors.blue.shade100,
              child: const Center(child: Text('Map View (Placeholder)')),
            ),
            const SizedBox(height: 20),
            const Text(
              'Recent Shipments:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(title: Text('Shipment 101 - On Route')),
                  ListTile(title: Text('Shipment 102 - Delivered')),
                  ListTile(title: Text('Shipment 103 - Awaiting Pickup')),
                ],
              ),
            ),
            ActionButton(
              text: 'Logout',
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool obscureText;

  const InputField({
    super.key,
    this.controller,
    required this.hintText,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hintText,
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
