part of 'account_bloc.dart';

class AccountState {
  AccountState({
    required this.userInfo,
    required this.resetFirstName,
    required this.resetLastName,
    required this.status,
    required this.errorMessage,
  });

  // UserInfo
  final User userInfo;
  final String resetFirstName;
  final String resetLastName;

  // Common
  final LoadStatus status;
  final String errorMessage;

  factory AccountState.initial() => AccountState(
        userInfo: User.empty(),
        resetFirstName: '',
        resetLastName: '',
        status: LoadStatus.initial,
        errorMessage: '',
      );

  AccountState copyWith({
    User? userInfo,
    String? resetFirstName,
    String? resetLastName,
    LoadStatus? status,
    String? errorMessage,
  }) {
    return AccountState(
      userInfo: userInfo ?? this.userInfo,
      resetFirstName: resetFirstName ?? this.resetFirstName,
      resetLastName: resetLastName ?? this.resetLastName,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
