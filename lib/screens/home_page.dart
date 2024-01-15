import 'package:flutter/material.dart';
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
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _loginBloc.add(const RequestLogout()),
              child: const Text('Logout'),
            ),
            const SizedBox(height: 32.0),
            const Text('Home Page'),
          ],
        ),
      ),
    );
  }
}
