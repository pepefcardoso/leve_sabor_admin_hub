import 'package:shared_preferences/shared_preferences.dart';

class LoginStore {
  static final LoginStore _singleton = LoginStore._();
  late final SharedPreferences _prefs;
  final String _token = "token";
  final String _lastEmail = 'last_email';

  late Future onReady;

  factory LoginStore() {
    return _singleton;
  }

  LoginStore._() {
    onReady = _init();
  }

  Future _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> storeToken(String token) async {
    await _prefs.setString(_token, token);
  }

  String getToken() {
    final String? token = _prefs.getString(_token);
    return token!;
  }

  String getAccessToken() {
    final String token = getToken();
    return "Bearer $token";
  }

  void revokeToken() {
    _prefs.remove(_token);
  }

  bool isLogged() {
    return _prefs.containsKey(_token);
  }

  void storeLastEmail(String email) {
    _prefs.setString(_lastEmail, email);
  }

  String? getLastEmail() {
    return _prefs.getString(_lastEmail);
  }

  void removeLastEmail() {
    _prefs.remove(_lastEmail);
  }
}
