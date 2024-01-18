import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:leve_sabor_admin_hub/model/user.dart';
import 'package:leve_sabor_admin_hub/utils/api_config.dart';
import 'package:leve_sabor_admin_hub/utils/http_exception.dart';

class LoginService {
  const LoginService();

  Future<String> login(String email, String password) async {
    try {
      final response = await Dio().post(
        '${ApiConfig.host}/api/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final String? token = response.data['token'];

      final String? error = response.data['error'];

      if (token != null) {
        return token;
      } else if (error != null) {
        throw HttpException(error);
      } else {
        throw const HttpException('Erro desconhecido');
      }
    } catch (error, stack) {
      if (error is DioException) {
        throw HttpException('Login inválido: ${error.message}');
      }

      if (kDebugMode) {
        log(error.toString());
        debugPrintStack(stackTrace: stack);
      }

      throw HttpException('Falha na conexão: ${error.toString()}');
    }
  }

  Future<void> logout({required String token}) async {
    try {
      await Dio().post(
        '${ApiConfig.host}/api/users/logout',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } catch (e) {
      log(e.toString());

      throw HttpException(e);
    }
  }

  Future<User> getUserData({required String token}) async {
    try {
      final response = await Dio().get(
        '${ApiConfig.host}/api/users/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final User user = User.fromJson(response.data);

      return user;
    } catch (e) {
      throw HttpException(e);
    }
  }
}
