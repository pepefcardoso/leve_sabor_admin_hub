import 'package:dio/dio.dart';
import 'package:leve_sabor_admin_hub/utils/api_config.dart';
import 'package:leve_sabor_admin_hub/utils/http_exception.dart';

class LoginService {
  const LoginService();

  Future<String> login(String email, String password) async {
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
  }

  Future<void> logout(String token) async {
    await Dio().post('${ApiConfig.host}/api/users/logout',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ));
  }
}
