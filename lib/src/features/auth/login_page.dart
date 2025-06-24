import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:test1/src/core/shared_prefs.dart';
import 'package:test1/src/features/auth/cubit/auth_cubit.dart';
import 'package:test1/src/features/auth/register_page.dart';
import 'package:test1/src/features/home/home_page.dart';
import 'package:test1/src/widgets/custom_input.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _login(BuildContext context) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No internet connection. Please connect and try again.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      return;
    }

    context.read<AuthCubit>().login(
      emailController.text,
      passwordController.text,
    );
  }

  void _goToRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => RegisterPage()),
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
    final theme = Theme.of(context);

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
        final isLoading = state is AuthLoading;

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
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.deepPurple.shade200,
                  ),
                ),
                const SizedBox(height: 40),

                CustomInput(label: 'Email', controller: emailController),
                const SizedBox(height: 20),
                CustomInput(
                  label: 'Password',
                  controller: passwordController,
                  isPassword: true,
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : () => _login(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: TextButton(
                    onPressed: () => _goToRegister(context),
                    child: Text(
                      'Don\'t have an account? Register here',
                      style: TextStyle(
                        color: Colors.deepPurple.shade400,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
