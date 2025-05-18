import 'package:flutter/material.dart';
import 'package:test1/src/core/shared_prefs.dart';
import 'package:test1/src/features/auth/login_page.dart';
import 'package:test1/src/features/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isLoggedIn = await SharedPrefs.isLoggedIn();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({required this.isLoggedIn, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Logistics App',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: isLoggedIn ? const HomePage() : const LoginPage(),
    );
  }
}
