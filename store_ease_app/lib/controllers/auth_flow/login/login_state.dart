part of 'login_bloc.dart';

class LoginState {
  LoginState({
    required this.password,
    required this.isPasswordVisible,
    required this.userId,
    required this.errorMessage,
    required this.status,
  });

  // Login
  final String password;
  final bool isPasswordVisible;
  final String userId;

  // Common
  final String errorMessage;
  final LoadStatus status;

  factory LoginState.initial() => LoginState(
        password: '',
        isPasswordVisible: false,
        userId: '',
        errorMessage: '',
        status: LoadStatus.initial,
      );

  LoginState copyWith({
    String? password,
    bool? isPasswordVisible,
    String? userId,
    String? errorMessage,
    LoadStatus? status,
  }) {
    return LoginState(
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      userId: userId ?? this.userId,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }
}
