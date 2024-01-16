import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kiwi/kiwi.dart';
import 'package:leve_sabor_admin_hub/bloc/login/login_bloc.dart';

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () => _loginBloc.add(const RequestLogout()),
            child: const Text('Logout'),
          ),
          const SizedBox(height: 32.0),
          Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => GoRouter.of(context).go('/home/blog-posts'),
                    icon: const Icon(Icons.book),
                    color: Colors.green,
                    iconSize: 36.0,
                  ),
                  const SizedBox(height: 8.0),
                  const Text('Posts do blog')
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
