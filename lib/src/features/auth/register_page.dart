import 'package:flutter/material.dart';
import 'package:test1/src/features/auth/auth_use_case.dart';
import 'package:test1/src/widgets/custom_input.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final useCase = AuthUseCase();

  bool _isLoading = false;

  void _register() async {
    setState(() {
      _isLoading = true;
    });

    final success = await useCase.register
      (emailController.text, passwordController.text);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registered successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration failed. Try again.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Account',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please fill the form to continue',
              style: theme.textTheme.titleMedium?.copyWith
                (color: Colors.deepPurple.shade200),
            ),
            const SizedBox(height: 40),
            CustomInput(
              label: 'Email',
              controller: emailController,
            ),
            const SizedBox(height: 20),
            CustomInput(
              label: 'Password',
              controller: passwordController,
              isPassword: true,
              // prefixIcon: const Icon(Icons.lock_outline),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  'Register',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                      color: Colors.white,),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Already have an account? Login',
                  style: TextStyle(color: Colors.deepPurple.shade400),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
