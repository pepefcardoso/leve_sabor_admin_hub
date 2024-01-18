import 'package:dio/dio.dart';
import 'package:leve_sabor_admin_hub/bloc/login/login_bloc.dart';
import 'package:leve_sabor_admin_hub/components/login_store.dart';
import 'package:leve_sabor_admin_hub/utils/http_exception.dart';

class Http {
  final Dio dio;
  final LoginStore loginStore;
  final LoginBloc loginBloc;

  Http({
    required this.dio,
    required this.loginStore,
    required this.loginBloc,
  });

  Options defaultOptions() {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (loginStore.isLogged()) {
      final String authorization = loginStore.getAccessToken();

      headers['Authorization'] = authorization;
    }

    return Options(
      headers: headers,
    );
  }

  Future<Response<T>> get<T>(String url, {Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      return await dio.get<T>(
        url,
        queryParameters: queryParameters,
        options: options ?? defaultOptions(),
      );
    } catch (e) {
      throw HttpException(e);
    }
  }

  Future<Response> getJson(String url, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await dio.get(
        url,
        queryParameters: queryParameters,
        options: defaultOptions(),
      );
    } catch (e) {
      throw HttpException(e);
    }
  }

  Future<Response> post(
    String url, {
    dynamic dados,
    Options? opcoes,
    Function(int enviado, int total)? progressoDeEnvio,
    Function(int enviado, int total)? progressoDeRecebimento,
  }) async {
    try {
      return await dio.post(
        url,
        data: dados,
        options: opcoes ?? defaultOptions(),
        onSendProgress: progressoDeEnvio,
        onReceiveProgress: progressoDeRecebimento,
      );
    } catch (e) {
      throw HttpException(e);
    }
  }

  Future<Response> postJson(String url, {dynamic dados}) async {
    try {
      return await dio.post(
        url,
        data: dados,
        options: defaultOptions(),
      );
    } catch (e) {
      throw HttpException(e);
    }
  }

  Future<Response> put(String url, {dynamic dados, Options? opcoes}) async {
    try {
      return await dio.put(
        url,
        data: dados,
        options: opcoes ?? defaultOptions(),
      );
    } catch (e) {
      throw HttpException(e);
    }
  }

  Future<Response> putJson(String url, {dynamic dados}) async {
    return put(
      url,
      dados: dados,
      opcoes: defaultOptions(),
    );
  }

  Future<Response> deleteJson(String url, {dynamic dados}) async {
    try {
      return await dio.delete(
        url,
        data: dados,
        options: defaultOptions(),
      );
    } catch (e) {
      throw HttpException(e);
    }
  }
}
