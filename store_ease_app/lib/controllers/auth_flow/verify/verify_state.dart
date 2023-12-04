part of 'verify_bloc.dart';

class VerifyState {
  VerifyState({
    this.token,
    required this.verificationCode,
    required this.verifyAttempts,
    required this.errorMessage,
    required this.status,
  });

  // Verify
  final String? token;
  final String verificationCode;
  int verifyAttempts;

  // Common
  final String errorMessage;
  final LoadStatus status;

  factory VerifyState.initial() => VerifyState(
        token: const Uuid().v4(),
        verificationCode: '',
        verifyAttempts: 0,
        errorMessage: '',
        status: LoadStatus.initial,
      );

  VerifyState copyWith({
    String? token,
    String? verificationCode,
    int? verifyAttempts,
    String? errorMessage,
    LoadStatus? status,
  }) {
    return VerifyState(
      token: token ?? this.token,
      verificationCode: verificationCode ?? this.verificationCode,
      verifyAttempts: verifyAttempts ?? this.verifyAttempts,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }
}
