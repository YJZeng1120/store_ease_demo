part of 'register_bloc.dart';

class RegisterState {
  RegisterState({
    required this.password,
    required this.isPasswordVisible,
    required this.confirmPassword,
    required this.isConfirmPasswordVisible,
    required this.firstName,
    required this.lastName,
    required this.errorMessage,
    required this.status,
  });

  // Register
  final String password;
  final bool isPasswordVisible;
  final String confirmPassword;
  final bool isConfirmPasswordVisible;
  final String firstName;
  final String lastName;

  // Common
  final String errorMessage;
  final LoadStatus status;

  factory RegisterState.initial() => RegisterState(
        password: '',
        isPasswordVisible: false,
        confirmPassword: '',
        isConfirmPasswordVisible: false,
        firstName: '',
        lastName: '',
        errorMessage: '',
        status: LoadStatus.initial,
      );

  RegisterState copyWith({
    String? password,
    bool? isPasswordVisible,
    String? confirmPassword,
    bool? isConfirmPasswordVisible,
    String? firstName,
    String? lastName,
    String? errorMessage,
    LoadStatus? status,
  }) {
    return RegisterState(
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }
}
