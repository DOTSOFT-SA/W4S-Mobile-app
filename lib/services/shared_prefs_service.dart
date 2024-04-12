import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  Future<bool> isUserLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLoggedIn") ?? false;
  }

  Future<bool> setLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool("isLoggedIn", true);
  }

  Future<bool> cacheCredentials(email, password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setStringList("credentials", [email, password]);
  }

  Future<int> getCachedScope() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("scope") ?? 0;
  }

  Future<bool> cacheScope(scope) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setInt("scope", scope);
  }

  Future<List> getCachedCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("credentials") ?? [];
  }

  Future<void> logOutUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('credentials');
    prefs.remove('isLoggedIn');
  }
}
