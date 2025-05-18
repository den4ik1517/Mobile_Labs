import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('user_email');
    final savedPassword = prefs.getString('user_password');

    return email == savedEmail && password == savedPassword;
  }

  Future<bool> register(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
    await prefs.setString('user_password', password);
    return true;
  }
}
