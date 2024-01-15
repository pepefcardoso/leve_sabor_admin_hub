import 'dart:developer';

import 'package:leve_sabor_admin_hub/utils/http.dart';
import 'package:leve_sabor_admin_hub/utils/http_exception.dart';

class UserService {
  final Http http;

  UserService({required this.http});

  Future<String> login(String email, String password) async {
    final response = await http.postJson(
      '/api/login',
      dados: {
        'email': email,
        'password': password,
      },
    );

    log('333332');

    final String? token = response.data['token'];

    final String? error = response.data['error'];

    log('111');

    if (token != null) {
      return token;
    } else if (error != null) {
      throw HttpException(error);
    } else {
      throw const HttpException('Erro desconhecido');
    }
  }

  Future<void> logout() async {
    await http.postJson('/logout');
  }
}
