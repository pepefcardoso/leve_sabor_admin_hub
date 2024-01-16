import 'dart:io' as dart_io;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:leve_sabor_admin_hub/bloc/login/login_bloc.dart';
import 'package:leve_sabor_admin_hub/services/blog_post_categories_service.dart';
import 'package:leve_sabor_admin_hub/services/blog_posts_service.dart';
import 'package:leve_sabor_admin_hub/services/user_service.dart';
import 'package:leve_sabor_admin_hub/utils/api_config.dart';
import 'package:leve_sabor_admin_hub/utils/http.dart';
import 'package:leve_sabor_admin_hub/utils/http_exception.dart';

class AppInitialization {
  static const _apiHost = ApiConfig.host;

  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    final globalKiwiContainer = KiwiContainer();

    late final Http http;

    late final UserService userService;

    try {
      globalKiwiContainer.registerFactory<Http>(
          (container) => Http(dio: Dio(BaseOptions(baseUrl: _apiHost))));

      http = globalKiwiContainer.resolve<Http>();

      globalKiwiContainer
          .registerFactory<UserService>((container) => UserService(http: http));

      userService = globalKiwiContainer.resolve<UserService>();

      globalKiwiContainer
          .registerFactory<LoginBloc>((container) => LoginBloc(userService));

      globalKiwiContainer.registerFactory<BlogPostsService>(
          (container) => BlogPostsService(http: http));

      globalKiwiContainer.registerFactory<BlogPostCategoriesService>(
          (container) => BlogPostCategoriesService(http: http));
    } on HttpException catch (httpException) {
      if (kDebugMode) {
        print(
            '[AppInitialization.initialize]: [HttpException] error in app initialization: "${httpException.mensagem}"');
      }
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(
            '[AppInitialization.initialize]: Generic error in app initialization: "$error"\nstackTrace: $stackTrace');
      }

      dart_io.exit(1);
    }
  }
}
