import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> saveUserData(String login, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('login', login);
    await prefs.setString('email', email);
  }

  Future<String?> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('login');
  }

  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('login');
    await prefs.remove('email');
  }
}
