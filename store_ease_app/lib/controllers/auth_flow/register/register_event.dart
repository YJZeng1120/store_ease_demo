part of 'register_bloc.dart';

abstract class RegisterEvent {
  const RegisterEvent();
}

// Register
class PasswordEvent extends RegisterEvent {
  const PasswordEvent(this.password);
  final String password;
}

class PasswordVisibleEvent extends RegisterEvent {
  const PasswordVisibleEvent();
}

class ConfirmPasswordEvent extends RegisterEvent {
  const ConfirmPasswordEvent(this.confirmPassword);
  final String confirmPassword;
}

class ConfirmPasswordVisibleEvent extends RegisterEvent {
  const ConfirmPasswordVisibleEvent();
}

class FirstNameEvent extends RegisterEvent {
  const FirstNameEvent(this.firstName);
  final String firstName;
}

class LastNameEvent extends RegisterEvent {
  const LastNameEvent(this.lastName);
  final String lastName;
}

class CreateUserEvent extends RegisterEvent {
  const CreateUserEvent(
    this.languageId,
    this.emailAddress,
  );
  final int languageId;
  final String emailAddress;
}
