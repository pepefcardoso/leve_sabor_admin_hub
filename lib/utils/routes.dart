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
            redirect: (context, state) {
              if (isLogged && !state.uri.path.contains('home')) {
                return '/home';
              } else if (!isLogged && !state.uri.path.contains('login')) {
                return '/login';
              }

              return null;
            },
            routes: [
              GoRoute(
                path: 'login',
                builder: (context, state) => const LoginPage(),
              ),
              GoRoute(
                path: 'home',
                builder: (context, state) => const HomePage(),
                routes: [
                  GoRoute(
                    path: 'blog-posts',
                    builder: (context, state) => const BlogPostsIndex(),
                    routes: [
                      GoRoute(
                        path: 'new',
                        builder: (context, state) => const BlogPostsForm(),
                      ),
                      GoRoute(
                        path: 'edit/:id',
                        builder: (context, state) => BlogPostsForm(id: int.parse(state.pathParameters['id']!)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      );
}
