import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:test1/src/core/shared_prefs.dart';
import 'package:test1/src/features/auth/auth_use_case.dart';
import 'package:test1/src/features/auth/register_page.dart';
import 'package:test1/src/features/home/home_page.dart';
import 'package:test1/src/widgets/custom_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final useCase = AuthUseCase();

  bool _isLoading = false;

  void _login() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No internet connection. '
              'Please connect and try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final success = await useCase.login(emailController.text,
        passwordController.text,);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      await SharedPrefs.setLoggedIn(true);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute<void>(builder: (_) => const HomePage()),
            (Route<dynamic> route) => false,
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login failed. Please check your credentials.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Welcome Back'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Log in to your account',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Enter your email and password below',
              style: theme.textTheme.titleMedium?.copyWith
                (color: Colors.deepPurple.shade200),
            ),
            const SizedBox(height: 40),

            CustomInput(label: 'Email', controller: emailController),
            const SizedBox(height: 20),
            CustomInput(label: 'Password', controller: passwordController,
                isPassword: true,),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(borderRadius:
                  BorderRadius.circular(12),),
                  elevation: 5,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  'Login',
                  style: TextStyle(fontSize: 18, fontWeight:
                  FontWeight.bold, color: Colors.white,),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: TextButton(
                onPressed: _goToRegister,
                child: Text(
                  'Don\'t have an account? Register here',
                  style: TextStyle(color: Colors.deepPurple.shade400,
                      fontWeight: FontWeight.w600,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
