import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test1/src/core/shared_prefs.dart';
import 'package:test1/src/features/auth/cubit/auth_cubit.dart';
import 'package:test1/src/features/home/home_page.dart';
import 'package:test1/src/widgets/custom_input.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _register(BuildContext context) {
    context.read<AuthCubit>().register(
      emailController.text,
      passwordController.text,
    );
  }

  void _onSuccess(BuildContext context) async {
    await SharedPrefs.setLoggedIn(true);
    await SharedPrefs.setEmail(emailController.text);
    await SharedPrefs.setPassword(passwordController.text);
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
            (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          _onSuccess(context);
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(title: const Text('Register')),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.person_add_alt_1,
                      size: 80, color: Colors.blueAccent),
                  const SizedBox(height: 20),
                  const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  CustomInput(label: 'Email', controller: emailController),
                  const SizedBox(height: 16),
                  CustomInput(
                    label: 'Password',
                    controller: passwordController,
                    isPassword: true,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.app_registration),
                    label: state is AuthLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Register'),
                    onPressed: state is AuthLoading
                        ? null
                        : () => _register(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
