import 'package:go_router/go_router.dart';
import 'package:leve_sabor_admin_hub/screens/home_page.dart';
import 'package:leve_sabor_admin_hub/screens/login_page.dart';

class Routes {
  bool isLogged;

  Routes(this.isLogged);

  GoRouter get router => GoRouter(
        routes: [
          GoRoute(
            path: '/',
            redirect: (_, __) {
              if (isLogged) {
                return '/home';
              }
              return '/login';
            },
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomePage(),
          ),
        ],
      );
}
