part of 'login_bloc.dart';

abstract class LoginEvent {
  const LoginEvent();
}

// Login
class LoginPasswordEvent extends LoginEvent {
  const LoginPasswordEvent(this.password);
  final String password;
}

class LoginPasswordVisibleEvent extends LoginEvent {
  const LoginPasswordVisibleEvent();
}

class LoginWithEmailEvent extends LoginEvent {
  const LoginWithEmailEvent(
    this.emailAddress,
    this.password,
    this.userId,
  );
  final String emailAddress;
  final String password;
  final String? userId;
}

class GetUserIdByUidEvent extends LoginEvent {
  const GetUserIdByUidEvent();
}
