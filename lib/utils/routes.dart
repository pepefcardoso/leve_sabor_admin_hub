import 'package:go_router/go_router.dart';
import 'package:leve_sabor_admin_hub/screens/blog_posts/blog_posts_form.dart';
import 'package:leve_sabor_admin_hub/screens/blog_posts/blog_posts_index.dart';
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
              return null;
            },
            builder: (context, state) => const LoginPage(),
            routes: [
              GoRoute(
                path: 'home',
                builder: (context, state) => const HomePage(),
              ),
              GoRoute(
                path: 'blog_posts',
                builder: (context, state) => const BlogPostsIndex(),
                routes: [
                  GoRoute(
                    path: 'new',
                    builder: (context, state) => const BlogPostsForm(),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
}
