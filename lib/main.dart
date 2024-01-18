import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:leve_sabor_admin_hub/app_initialization.dart';
import 'package:leve_sabor_admin_hub/bloc/login/login_bloc.dart';
import 'package:leve_sabor_admin_hub/utils/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  await AppInitialization().initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Routes routes = Routes(false);
  late final LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();

    final kiwi = KiwiContainer();

    loginBloc = kiwi.resolve<LoginBloc>();

    if (loginBloc.state.isLoggedIn) {
      routes.isLogged = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: loginBloc,
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.loggedOut) {
            routes.isLogged = false;
          } else if (state.status == LoginStatus.loggedIn) {
            routes.isLogged = true;
          } else {
            return;
          }
          setState(() {
            routes.router.go('/');
          });
        },
        child: MaterialApp.router(
          title: 'Leve Sabor AdminHub',
          debugShowCheckedModeBanner: false,
          routerConfig: routes.router,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
            useMaterial3: true,
          ),
        ),
      ),
    );
  }
}
