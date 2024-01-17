part of 'login_bloc.dart';

enum LoginStatus { initial, loggingIn, loggedIn, loggingOut, loggedOut, error }

@immutable
class LoginState {
  final LoginStatus status;
  final String? token;
  final User? user;
  final String? error;

  const LoginState({
    required this.status,
    this.token,
    this.user,
    this.error,
  });

  LoginState copyWith({
    LoginStatus? status,
    String? token,
    User? user,
    String? error,
  }) {
    return LoginState(
      status: status ?? this.status,
      token: token ?? this.token,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }

  bool get isLoggingIn {
    return (status == LoginStatus.loggingIn);
  }

  bool get isLoggedIn {
    return (status == LoginStatus.loggedIn);
  }
}
