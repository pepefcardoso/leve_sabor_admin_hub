import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:leve_sabor_admin_hub/bloc/login/login_bloc.dart';
import 'package:leve_sabor_admin_hub/components/home_page_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final KiwiContainer _kiwiContainer = KiwiContainer();
  late final LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();

    _loginBloc = _kiwiContainer.resolve<LoginBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leve Sabor'),
        backgroundColor: Colors.green[900],
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            onPressed: () => _loginBloc.add(const RequestLogout()),
            color: Colors.white,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          children: [
            Row(
              children: [
                HomePageButton(
                  label: 'Users',
                  icon: Icons.supervised_user_circle,
                  route: '/home/users',
                ),
                SizedBox(width: 16.0),
                HomePageButton(
                  label: 'Businesses',
                  icon: Icons.business,
                  route: '/home/businesses',
                ),
                SizedBox(width: 16.0),
                HomePageButton(
                  label: 'Reviews',
                  icon: Icons.star,
                  route: '/home/reviews',
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                HomePageButton(
                  label: 'Roles',
                  icon: Icons.person,
                  route: '/home/roles',
                ),
                SizedBox(width: 16.0),
                HomePageButton(
                  label: 'Blog Posts',
                  icon: Icons.book_outlined,
                  route: '/home/blog-posts',
                ),
                SizedBox(width: 16.0),
                HomePageButton(
                  label: 'Blog Post Categories',
                  icon: Icons.bookmark_add,
                  route: '/home/blog-posts-categories',
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                HomePageButton(
                  label: 'Diets',
                  icon: Icons.food_bank_outlined,
                  route: '/home/diets',
                ),
                SizedBox(width: 16.0),
                HomePageButton(
                  label: 'Business Categories',
                  icon: Icons.list_alt_sharp,
                  route: '/home/business-categories',
                ),
                SizedBox(width: 16.0),
                HomePageButton(
                  label: 'Cooking Styles',
                  icon: Icons.kitchen,
                  route: '/home/cooking-styles',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
