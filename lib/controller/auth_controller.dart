import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  static const String _loginKey = 'loginData';
  static const String _usernameKey = 'username';

  static const String validUsername = 'nathiq';
  static const String validPassword = '141';

  final RxBool _isLoggedIn = false.obs;
  final RxString _currentUsername = ''.obs;

  bool get isLoggedIn => _isLoggedIn.value;
  String get currentUsername => _currentUsername.value;

  Future<void> checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool(_loginKey) ?? false;
    final savedUsername = prefs.getString(_usernameKey) ?? '';

    if (loggedIn && savedUsername.isNotEmpty) {
      _isLoggedIn.value = true;
      _currentUsername.value = savedUsername;
    } else {
      _isLoggedIn.value = false;
      _currentUsername.value = '';
    }
  }

  Future<String?> login(String rawUsername, String rawPassword) async {
    final username = rawUsername.trim();
    final password = rawPassword.trim();

    if (username.isEmpty || password.isEmpty) {
      return 'Username dan Password tidak boleh kosong!';
    }

    if (username.toLowerCase() != validUsername || password != validPassword) {
      return 'Login Gagal: Username atau Password salah';
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginKey, true);
    await prefs.setString(_usernameKey, username);

    _isLoggedIn.value = true;
    _currentUsername.value = username;

    Get.offAllNamed(AppRoutes.home);
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginKey, false);
    await prefs.remove(_usernameKey);

    _isLoggedIn.value = false;
    _currentUsername.value = '';

    Get.offAllNamed(AppRoutes.login);
  }
}
