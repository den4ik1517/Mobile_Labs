import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:test1/src/core/shared_prefs.dart';
import 'package:test1/src/features/auth/auth_repository.dart';
import 'package:test1/src/features/auth/auth_use_case.dart';
import 'package:test1/src/features/auth/cubit/auth_cubit.dart';
import 'package:test1/src/features/auth/login_page.dart';
import 'package:test1/src/features/home/home_page.dart';
import 'package:test1/src/features/home/mqtt_service.dart';
import 'package:test1/src/features/home/cubit/home_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();

  final authRepository = AuthRepository();
  final authUseCase = AuthUseCase(authRepository);
  final connectivity = Connectivity();
  final mqttClient = MQTTClientWrapper(
    host: '0493295c8cb54e298c1d606ed7430d9e.s1.eu.hivemq.cloud',
    clientIdentifier: 'flutter_client_main',
    username: 'denys',
    password: 'Qwerty123',
    onData: ({int? temperature, int? humidity, int? pressure}) {},
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(authUseCase),
        ),
        BlocProvider<HomeCubit>(
          create: (_) => HomeCubit(
            mqttClient: mqttClient,
            connectivity: connectivity,
          )..init(),
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
      theme: ThemeData(primarySwatch: Colors.teal),
      home: SplashPage(),
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
      if (connectivityResult == ConnectivityResult.none && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No internet connection. Some features may be limited.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
        );
      }
    } else {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
