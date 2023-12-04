part of 'user_watcher_bloc.dart';

class UserWatcherState {
  UserWatcherState({
    required this.password,
    required this.isDeleted,
    required this.deleteStatus,
    required this.loggedIn,
    required this.errorMessage,
    required this.authStatus,
  });

  // Delete account
  final String password;
  final bool isDeleted;
  final LoadStatus deleteStatus;

  // LoginCache
  final bool loggedIn;

  // Common
  final String errorMessage;
  final LoadStatus authStatus;

  factory UserWatcherState.initial() => UserWatcherState(
        password: '',
        isDeleted: false,
        deleteStatus: LoadStatus.initial,
        loggedIn: false,
        errorMessage: '',
        authStatus: LoadStatus.initial,
      );

  UserWatcherState copyWith({
    String? password,
    bool? isDeleted,
    LoadStatus? deleteStatus,
    bool? loggedIn,
    String? errorMessage,
    LoadStatus? authStatus,
  }) {
    return UserWatcherState(
      password: password ?? this.password,
      isDeleted: isDeleted ?? this.isDeleted,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      loggedIn: loggedIn ?? this.loggedIn,
      errorMessage: errorMessage ?? this.errorMessage,
      authStatus: authStatus ?? this.authStatus,
    );
  }
}
