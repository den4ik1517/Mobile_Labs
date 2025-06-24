import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test1/src/core/shared_prefs.dart';
import 'package:test1/src/data/user_repository.dart';
import 'package:test1/src/features/auth/auth_repository.dart';
import 'package:test1/src/features/auth/auth_use_case.dart';
import 'package:test1/src/features/auth/cubit/auth_cubit.dart';
import 'package:test1/src/features/auth/login_page.dart';
import 'package:test1/src/features/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();

  final authRepository = AuthRepository();
  final authUseCase = AuthUseCase(authRepository);

  final userRepository = UserRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(authUseCase),
        ),
        BlocProvider<ProfileCubit>(
          create: (_) => ProfileCubit(userRepository),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Logistics App',
      debugShowCheckedModeBanner: false,
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

    if (!mounted) return;

    if (isLoggedIn) {
      if (connectivityResult == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No internet connection. Some features may be limited.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
