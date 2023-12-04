part of 'auth_bloc.dart';

class AuthState {
  AuthState({
    required this.emailAddress,
    required this.userId,
    required this.errorMessage,
    required this.status,
  });

  // Auth
  final String emailAddress;
  final String userId; // 使用userId來判斷是login或register

  // Common
  final String errorMessage;
  final LoadStatus status;

  factory AuthState.initial() => AuthState(
        emailAddress: '',
        userId: '',
        errorMessage: '',
        status: LoadStatus.initial,
      );

  AuthState copyWith({
    String? emailAddress,
    String? userId,
    String? errorMessage,
    LoadStatus? status,
  }) {
    return AuthState(
      emailAddress: emailAddress ?? this.emailAddress,
      userId: userId ?? this.userId,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }
}
