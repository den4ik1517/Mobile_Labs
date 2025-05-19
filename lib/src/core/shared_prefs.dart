import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool('loggedIn', value);
  }

  static bool getLoggedIn() {
    return _prefs.getBool('loggedIn') ?? false;
  }

  static Future<void> setEmail(String email) async {
    await _prefs.setString('email', email);
  }

  static String? getEmail() {
    return _prefs.getString('email');
  }

  static Future<void> setPassword(String password) async {
    await _prefs.setString('password', password);
  }

  static String? getPassword() {
    return _prefs.getString('password');
  }
}
