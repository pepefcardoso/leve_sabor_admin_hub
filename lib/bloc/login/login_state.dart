part of 'login_bloc.dart';

enum LoginStatus { logged, logging, notLogged, error }

@immutable
class LoginState {
  final String? token;
  final LoginStatus status;
  final String? error;

  const LoginState({
    this.token,
    this.status = LoginStatus.notLogged,
    this.error,
  });

  LoginState copyWith({
    String? token,
    LoginStatus? status,
    String? error,
    bool? loggedOut,
  }) {
    return LoginState(
      token: loggedOut == true ? null : token ?? this.token,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
