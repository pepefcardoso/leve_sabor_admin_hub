import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leve_sabor_admin_hub/bloc/login/login_bloc.dart';
import 'package:leve_sabor_admin_hub/utils/tipografia.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _senhaController;
  late final String? _lastEmail;
  late final LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();

    _loginBloc = BlocProvider.of<LoginBloc>(context);

    _lastEmail = _loginBloc.loginStore.getLastEmail();

    _emailController = TextEditingController(text: _lastEmail);
    _senhaController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state.status == LoginStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error!),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Login',
                    style: Tipografia.titulo1,
                  ),
                  const SizedBox(height: 24.0),
                  if (state.status == LoginStatus.loggingIn) ...[
                    const Center(child: CircularProgressIndicator()),
                    const SizedBox(height: 12.0),
                  ] else ...[
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: _senhaController,
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                      ),
                      onChanged: (ssss) {},
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        _loginBloc.add(
                          RequestLogin(
                            email: _emailController.text,
                            password: _senhaController.text,
                          ),
                        );
                      },
                      child: const Text('Entrar'),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
