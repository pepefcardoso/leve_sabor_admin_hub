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
        child: Row(
          children: [
            HomePageButton(
              label: 'Blog Posts',
              icon: Icons.book_outlined,
              route: '/home/blog-posts',
            ),
          ],
        ),
      ),
    );
  }
}
