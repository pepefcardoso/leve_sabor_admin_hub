part of 'login_bloc.dart';

abstract class LoginEvent {
  const LoginEvent();
}

class RequestLogin extends LoginEvent {
  final String email;
  final String password;

  const RequestLogin({
    required this.email,
    required this.password,
  });
}

class RequestGetAccessToken extends LoginEvent {
  const RequestGetAccessToken();
}

class RequestLogout extends LoginEvent {
  const RequestLogout();
}
