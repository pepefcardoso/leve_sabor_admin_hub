import 'dart:io' as dart_io;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:leve_sabor_admin_hub/bloc/login/login_bloc.dart';
import 'package:leve_sabor_admin_hub/components/login_store.dart';
import 'package:leve_sabor_admin_hub/model/user.dart';
import 'package:leve_sabor_admin_hub/services/blog_post_categories_service.dart';
import 'package:leve_sabor_admin_hub/services/blog_posts_service.dart';
import 'package:leve_sabor_admin_hub/services/login_service.dart';
import 'package:leve_sabor_admin_hub/utils/api_config.dart';
import 'package:leve_sabor_admin_hub/utils/http.dart';
import 'package:leve_sabor_admin_hub/utils/http_exception.dart';

class AppInitialization {
  static const _apiHost = ApiConfig.host;

  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Setting up login flow
    LoginService loginService = const LoginService();
    final LoginStore loginStore = LoginStore();
    await loginStore.onReady;
    late LoginState initialLoginState;

    if (loginStore.isLogged()) {
      final String token = loginStore.getToken();

      try {
        User user = await loginService.getUserData(token: token);

        initialLoginState = LoginState(
          status: LoginStatus.loggedIn,
          user: user,
        );
      } catch (e) {
        if (kDebugMode) {
          print('[AppInitialization.initialize]: Generic error in app initialization: "$e"');
        }

        initialLoginState = const LoginState(status: LoginStatus.loggedOut);
      }
    } else {
      initialLoginState = const LoginState(status: LoginStatus.loggedOut);
    }

    final LoginBloc loginBloc = LoginBloc(
      loginService: loginService,
      loginStore: loginStore,
      state: initialLoginState,
    );

    final Http http = Http(
      dio: Dio(BaseOptions(baseUrl: _apiHost)),
      loginBloc: loginBloc,
      loginStore: loginStore,
    );

    final KiwiContainer kiwi = KiwiContainer();

    try {
      kiwi.registerSingleton<Http>((c) => http);

      kiwi.registerSingleton<LoginStore>((c) => loginStore);

      kiwi.registerSingleton<LoginBloc>((c) => loginBloc);

      kiwi.registerFactory<BlogPostsService>((container) => BlogPostsService(http: http));

      kiwi.registerFactory<BlogPostCategoriesService>((container) => BlogPostCategoriesService(http: http));
    } on HttpException catch (httpException) {
      if (kDebugMode) {
        print('[AppInitialization.initialize]: [HttpException] error in app initialization: "${httpException.mensagem}"');
      }
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print('[AppInitialization.initialize]: Generic error in app initialization: "$error"\nstackTrace: $stackTrace');
      }

      dart_io.exit(1);
    }
  }
}
