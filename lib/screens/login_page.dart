import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:leve_sabor_admin_hub/bloc/login/login_bloc.dart';
import 'package:leve_sabor_admin_hub/components/custom_text_formfield.dart';
import 'package:leve_sabor_admin_hub/utils/custom_colors.dart';
import 'package:leve_sabor_admin_hub/utils/tipografia.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _senhaController;
  late final String? _lastEmail;
  late final LoginBloc _loginBloc;

  String? _onSubmit() {
    if (_formKey.currentState!.validate()) {
      _loginBloc.add(RequestLogin(
        email: _emailController.text,
        password: _senhaController.text,
      ));
    }

    return null;
  }

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
      backgroundColor: Colors.grey[400],
      body: BlocConsumer<LoginBloc, LoginState>(
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
          return Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                width: MediaQuery.of(context).size.width * 0.85,
                child: Card(
                  surfaceTintColor: Colors.grey[300],
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                  child: Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            bottomLeft: Radius.circular(16.0),
                          ),
                          child: Image.asset(
                            'assets/images/login_page_cover.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(48.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const _LogoCard(),
                                const SizedBox(height: 16.0),
                                const Text(
                                  'Olá! Seja bem vindo de volta!',
                                  style: Tipografia.titulo4,
                                ),
                                const SizedBox(height: 48.0),
                                if (state.status == LoginStatus.loggingIn) ...[
                                  const Center(child: CircularProgressIndicator()),
                                ] else ...[
                                  CustomTextField(
                                    controller: _emailController,
                                    labelText: 'E-mail',
                                    hintText: 'Digite seu e-mail',
                                    icon: Icons.email,
                                    validator: (value) => EmailValidator.validate(value ?? '') ? null : "Email inválido",
                                  ),
                                  const SizedBox(height: 16.0),
                                  CustomTextField(
                                    controller: _senhaController,
                                    labelText: 'Senha',
                                    obscureText: true,
                                    hintText: 'Digite sua senha',
                                    icon: Icons.lock,
                                    validator: (value) {
                                      if (value == null || value.isEmpty || value.length < 8) {
                                        return 'Senha inválida';
                                      }

                                      return null;
                                    },
                                    onSubmitted: (_) => _onSubmit(),
                                  ),
                                  const SizedBox(height: 24.0),
                                  SizedBox(
                                    height: 48.0,
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 4.0,
                                        backgroundColor: CustomColors.verde1,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                                      ),
                                      onPressed: _onSubmit,
                                      child: Text(
                                        'Entrar',
                                        style: Tipografia.titulo2.copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LogoCard extends StatelessWidget {
  const _LogoCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 4.0,
      color: CustomColors.verde1,
      child: SizedBox(
        height: 120.0,
        width: 120.0,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SvgPicture.asset(
            'assets/svg/logo_svg.svg',
            height: 38.0,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
