import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:test1/src/core/shared_prefs.dart';
import 'package:test1/src/features/auth/login_page.dart';
import 'package:test1/src/features/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init(); // Ініціалізуємо SharedPreferences перед запуском

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Logistics App',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _tryAutoLogin();
  }

  void _tryAutoLogin() async {
    final isLoggedIn = SharedPrefs.getLoggedIn();
    final connectivityResult = await Connectivity().checkConnectivity();

    if (isLoggedIn) {
      if (connectivityResult == ConnectivityResult.none) {
        // Автологін без мережі — показати попередження і пустити у Home
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No internet connection. Some features may be limited.',
            ),
            backgroundColor: Colors.orange,
          ),
        );
        Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(builder: (_) => const HomePage()),
        );
      } else {
        if (!mounted) return;
        Navigator.pushReplacement<void, void>(
            context, MaterialPageRoute(builder: (_) => const HomePage()),);
      }
    } else {
      if (!mounted) return;
      Navigator.pushReplacement<void, void>(
          context, MaterialPageRoute(builder: (_) => const LoginPage()),);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
