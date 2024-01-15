import 'package:dio/dio.dart';

class HttpException implements Exception {
  final dynamic error;

  const HttpException(this.error);

  int? get codigoHttp {
    if (error is DioException) {
      final response = (error as DioException).response;
      return response?.statusCode;
    }
    return null;
  }

  String get mensagem {
    if (error is DioException) {
      final response = (error as DioException).response;

      if (response != null) {
        if (response.data is Map<String, dynamic> && response.data['message'] != null && response.data['message'] is String) {
          return response.data['message'];
        }

        if (response.statusCode == 400) {
          return 'Não foi possível completar ação';
        }

        if (response.statusCode == 401) {
          return 'Não autorizado';
        }

        if (response.statusCode == 403) {
          return 'Sem permissão';
        }

        if (response.statusCode == 404) {
          return 'Recurso não encontrado';
        }

        if (response.statusCode == 422) {
          if (response.data is Map) {
            var erros = [];
            response.data.values.forEach((e) {
              if (e is List) {
                for (var i = 0; i < e.length; i++) {
                  erros.add(e[i]);
                }
              } else if (e is String) {
                erros.add(e);
              }
            });
            return erros.join("\n");
          } else {
            return '';
          }
        }
      }
    }

    if (error is String) {
      return error;
    }

    return 'Falha na conexão';
  }
}
