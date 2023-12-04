part of 'forgot_password_bloc.dart';

class ForgotPasswordState {
  ForgotPasswordState({
    required this.password,
    required this.isPasswordVisible,
    required this.confirmPassword,
    required this.isConfirmPasswordVisible,
    required this.errorMessage,
    required this.status,
  });

  // Reset Password
  final String password;
  final bool isPasswordVisible;
  final String confirmPassword;
  final bool isConfirmPasswordVisible;

  // Common
  final String errorMessage;
  final LoadStatus status;

  factory ForgotPasswordState.initial() => ForgotPasswordState(
        password: '',
        isPasswordVisible: false,
        confirmPassword: '',
        isConfirmPasswordVisible: false,
        errorMessage: '',
        status: LoadStatus.initial,
      );

  ForgotPasswordState copyWith({
    String? password,
    bool? isPasswordVisible,
    String? confirmPassword,
    bool? isConfirmPasswordVisible,
    String? errorMessage,
    LoadStatus? status,
  }) {
    return ForgotPasswordState(
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }
}
