import 'package:shared_preferences/shared_preferences.dart';

class LoginStore {
  static final LoginStore _singleton = LoginStore._();
  late final SharedPreferences _prefs;
  final String _token = "token";
  final String _lastUsername = 'last_username';

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

  void storeToken(String token) async {
    _prefs.setString(_token, token);
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

  void storeLastUsername(String username) {
    _prefs.setString(_lastUsername, username);
  }

  String? recuperarUltimoUsername() {
    return _prefs.getString(_lastUsername);
  }

  void removerUltimoUsername() {
    _prefs.remove(_lastUsername);
  }
}
