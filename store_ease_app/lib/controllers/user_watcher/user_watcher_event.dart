part of 'user_watcher_bloc.dart';

abstract class UserWatcherEvent {
  const UserWatcherEvent();
}

// LoginCache
class CacheLoginInfoEvent extends UserWatcherEvent {
  const CacheLoginInfoEvent();
}

// Logout
class LogoutEvent extends UserWatcherEvent {
  const LogoutEvent();
}

// Delete account
class VerifyPasswordEvent extends UserWatcherEvent {
  const VerifyPasswordEvent(this.password);
  final String password;
}

class DeleteVerifyEvent extends UserWatcherEvent {
  const DeleteVerifyEvent(
    this.email,
    this.password,
  );
  final String email;
  final String password;
}

class DeleteUserEvent extends UserWatcherEvent {
  const DeleteUserEvent();
}

// Common
class ResetErrorMessageEvent extends UserWatcherEvent {
  const ResetErrorMessageEvent();
}
