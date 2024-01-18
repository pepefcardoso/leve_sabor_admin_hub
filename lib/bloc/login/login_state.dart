part of 'login_bloc.dart';

enum LoginStatus { initial, loggingIn, loggedIn, loggingOut, loggedOut, error }

@immutable
class LoginState {
  final LoginStatus status;
  final User? user;
  final String? error;

  const LoginState({
    required this.status,
    this.user,
    this.error,
  });

  LoginState copyWith({
    LoginStatus? status,
    User? user,
    String? error,
    bool loggedOut = false,
  }) {
    return LoginState(
      status: status ?? this.status,
      user: loggedOut ? null : user ?? this.user,
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
