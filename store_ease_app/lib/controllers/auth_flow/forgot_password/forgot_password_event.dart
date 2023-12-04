part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent {
  const ForgotPasswordEvent();
}

// Reset Password
class PasswordEvent extends ForgotPasswordEvent {
  const PasswordEvent(this.password);
  final String password;
}

class PasswordVisibleEvent extends ForgotPasswordEvent {
  const PasswordVisibleEvent();
}

class ConfirmPasswordEvent extends ForgotPasswordEvent {
  const ConfirmPasswordEvent(this.confirmPassword);
  final String confirmPassword;
}

class ConfirmPasswordVisibleEvent extends ForgotPasswordEvent {
  const ConfirmPasswordVisibleEvent();
}

class ResetPasswordEvent extends ForgotPasswordEvent {
  const ResetPasswordEvent(this.userId);
  final String userId;
}
