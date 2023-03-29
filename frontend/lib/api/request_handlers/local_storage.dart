import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('token');
    return authToken;
  }
}
