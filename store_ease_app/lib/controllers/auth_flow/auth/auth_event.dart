part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent();
}

// Auth
class EmailAddressEvent extends AuthEvent {
  const EmailAddressEvent(this.emailAddress);
  final String emailAddress;
}

class CheckHasUserEvent extends AuthEvent {
  const CheckHasUserEvent();
}
